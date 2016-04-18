#!/bin/bash
set -e

ENV_FILE=/run/coreos-kubernetes/options.env
export $(cat $ENV_FILE | xargs)

function template {
	# use a heredoc so the quoting & whitespace in the
	# downloaded artifact is preserved, but env variables
	# can still be evaluated
	eval "cat <<EOF
$(curl --silent -L "${ARTIFACT_URL}/$1")
EOF
" > $2
}

function init_config {
	local REQUIRED=('ADVERTISE_IP' 'POD_NETWORK' 'ETCD_ENDPOINTS' 'SERVICE_NETWORK' 'K8S_SERVICE_IP' 'DNS_SERVICE_IP' 'K8S_VER' 'ARTIFACT_URL' )

	if [ -z $ADVERTISE_IP ]; then
		export ADVERTISE_IP=$(awk -F= '/COREOS_PRIVATE_IPV4/ {print $2}' /etc/environment)
	fi

	for REQ in "${REQUIRED[@]}"; do
		if [ -z "$(eval echo \$$REQ)" ]; then
			echo "Missing required config value: ${REQ}"
			exit 1
		fi
	done
}

function init_flannel {
	echo "Waiting for etcd..."
	while true
	do
		IFS=',' read -ra ES <<< "$ETCD_ENDPOINTS"
		for ETCD in "${ES[@]}"; do
			echo "Trying: $ETCD"
			if [ -n "$(curl --silent "$ETCD/v2/machines")" ]; then
				local ACTIVE_ETCD=$ETCD
				break
			fi
			sleep 1
		done
		if [ -n "$ACTIVE_ETCD" ]; then
			break
		fi
	done
	RES=$(curl --silent -X PUT -d "value={\"Network\":\"$POD_NETWORK\"}" "$ACTIVE_ETCD/v2/keys/coreos.com/network/config?prevExist=false")
	if [ -z "$(echo $RES | grep '"action":"create"')" ] && [ -z "$(echo $RES | grep 'Key already exists')" ]; then
		echo "Unexpected error configuring flannel pod network: $RES"
	fi
}

function init_templates {
	local TEMPLATE=/etc/systemd/system/kubelet.service
	[ -f $TEMPLATE ] || {
		echo "TEMPLATE: $TEMPLATE"
		mkdir -p $(dirname $TEMPLATE)
		cat << EOF > $TEMPLATE
[Service]
ExecStartPre=/usr/bin/mkdir -p /etc/kubernetes/manifests
ExecStart=/usr/bin/kubelet \
  --api_servers=http://127.0.0.1:8080 \
  --register-node=false \
  --allow-privileged=true \
  --config=/etc/kubernetes/manifests \
  --cluster_dns=${DNS_SERVICE_IP} \
  --cluster_domain=cluster.local
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
	}

	mkdir -p /etc/kubernetes/manifests
	template manifests/controller/kube-proxy.yaml /etc/kubernetes/manifests/kube-proxy.yaml
	template manifests/controller/kube-apiserver.yaml /etc/kubernetes/manifests/kube-apiserver.yaml
	template manifests/controller/kube-podmaster.yaml /etc/kubernetes/manifests/kube-podmaster.yaml

	mkdir -p /srv/kubernetes/manifests
	template manifests/controller/kube-controller-manager.yaml /srv/kubernetes/manifests/kube-controller-manager.yaml
	template manifests/controller/kube-scheduler.yaml /srv/kubernetes/manifests/kube-scheduler.yaml

	template manifests/cluster/kube-system.json /srv/kubernetes/manifests/kube-system.json
	template manifests/cluster/kube-dns-rc.json /srv/kubernetes/manifests/kube-dns-rc.json
	template manifests/cluster/kube-dns-svc.json /srv/kubernetes/manifests/kube-dns-svc.json

	local TEMPLATE=/etc/flannel/options.env
	[ -f $TEMPLATE ] || {
		echo "TEMPLATE: $TEMPLATE"
		mkdir -p $(dirname $TEMPLATE)
		cat << EOF > $TEMPLATE
FLANNELD_IFACE=$ADVERTISE_IP
FLANNELD_ETCD_ENDPOINTS=$ETCD_ENDPOINTS
EOF
	 }

	local TEMPLATE=/etc/systemd/system/flanneld.service.d/40-ExecStartPre-symlink.conf.conf
	[ -f $TEMPLATE ] || {
		echo "TEMPLATE: $TEMPLATE"
		mkdir -p $(dirname $TEMPLATE)
		cat << EOF > $TEMPLATE
[Service]
ExecStartPre=/usr/bin/ln -sf /etc/flannel/options.env /run/flannel/options.env
EOF
	}

	local TEMPLATE=/etc/systemd/system/docker.service.d/40-flannel.conf
	[ -f $TEMPLATE ] || {
		echo "TEMPLATE: $TEMPLATE"
		mkdir -p $(dirname $TEMPLATE)
		cat << EOF > $TEMPLATE
[Unit]
Requires=flanneld.service
After=flanneld.service
EOF
	}
}

function start_addons {
	echo "Waiting for Kubernetes API..."
	until curl --silent "http://127.0.0.1:8080/version"
	do
		sleep 5
	done
	echo
	echo "K8S: kube-system namespace"
	curl --silent -H "Content-Type: application/json" -XPOST -d"$(cat /srv/kubernetes/manifests/kube-system.json)" "http://127.0.0.1:8080/api/v1/namespaces" > /dev/null
	echo "K8S: DNS addon"
	curl --silent -H "Content-Type: application/json" -XPOST -d"$(cat /srv/kubernetes/manifests/kube-dns-rc.json)" "http://127.0.0.1:8080/api/v1/namespaces/kube-system/replicationcontrollers" > /dev/null
	curl --silent -H "Content-Type: application/json" -XPOST -d"$(cat /srv/kubernetes/manifests/kube-dns-svc.json)" "http://127.0.0.1:8080/api/v1/namespaces/kube-system/services" > /dev/null
}

init_config
init_templates

init_flannel

systemctl daemon-reload
systemctl enable kubelet
systemctl start kubelet
systemctl start fleet
start_addons
echo "DONE"

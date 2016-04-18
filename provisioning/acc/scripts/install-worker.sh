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
	local REQUIRED=( 'ADVERTISE_IP' 'ETCD_ENDPOINTS' 'CONTROLLER_ENDPOINT' 'DNS_SERVICE_IP' 'K8S_VER' 'ARTIFACT_URL' )

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

function init_docker {
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

	# reload now before docker commands are run in later
	# init steps or dockerd will start before flanneld
	systemctl daemon-reload
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
  --api_servers=${CONTROLLER_ENDPOINT} \
  --register-node=true \
  --allow-privileged=true \
  --config=/etc/kubernetes/manifests \
  --cluster_dns=${DNS_SERVICE_IP} \
  --cluster_domain=cluster.local \
  --cloud-provider=aws \
  --kubeconfig=/etc/kubernetes/worker-kubeconfig.yaml \
  --tls-cert-file=/etc/kubernetes/ssl/worker.pem \
  --tls-private-key-file=/etc/kubernetes/ssl/worker-key.pem
Restart=always
RestartSec=10
[Install]
WantedBy=multi-user.target
EOF
	}

	mkdir -p /etc/kubernetes/manifests
	template manifests/worker/kubeconfig /etc/kubernetes/worker-kubeconfig.yaml
	template manifests/worker/kube-proxy.yaml /etc/kubernetes/manifests/kube-proxy.yaml

	local TEMPLATE=/run/flannel/options.env
	[ -f $TEMPLATE ] || {
		echo "TEMPLATE: $TEMPLATE"
		mkdir -p $(dirname $TEMPLATE)
		cat << EOF > $TEMPLATE
FLANNELD_IFACE=$ADVERTISE_IP
FLANNELD_ETCD_ENDPOINTS=$ETCD_ENDPOINTS
EOF
	}

}

init_config
init_templates
init_docker

systemctl daemon-reload

systemctl enable kubelet
systemctl start kubelet
systemctl start fleet

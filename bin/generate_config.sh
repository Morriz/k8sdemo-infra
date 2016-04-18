#!/usr/bin/env bash
. lib/functions.sh


ACC_K8S_MASTER=acc-k8s.your.com
PROD_K8S_MASTER=prod-k8s.your.com

# acceptance
rm -rf ssl/acc/*
sh lib/init-ssl-ca ssl/acc
sh lib/init-ssl ssl/acc admin kube-admin $ACC_K8S_MASTER
sh lib/init-ssl ssl/acc apiserver kube-apiserver kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local,$ACC_DOMAIN
sh lib/init-ssl ssl/acc worker kube-worker *.*.compute.internal,*.ec2.internal
#openssl dhparam -out ssl/acc/dhparam.pem 2048

# prod
rm -rf ssl/prod/*
sh lib/init-ssl-ca ssl/prod
sh lib/init-ssl ssl/prod admin kube-admin $PROD_K8S_MASTER
sh lib/init-ssl ssl/prod apiserver kube-apiserver kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local,$ACC_DOMAIN
sh lib/init-ssl ssl/prod worker kube-worker *.*.compute.internal,*.ec2.internal
#openssl dhparam -out ssl/prod/dhparam.pem 2048

printf "%s\n" "$(apply_shell_expansion tpl/kubeconfig)" > k8s/kubeconfig

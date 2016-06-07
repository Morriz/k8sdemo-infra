#!/usr/bin/env bash
. lib/functions.sh


ACC_IPS=172.20.0.50,172.23.0.1
ACC_K8S_MASTER=acc-k8s.your.com

PROD_IPS=172.21.0.50,172.25.0.1
PROD_K8S_MASTER=prod-k8s.your.com

# acceptance
rm -rf ssl/acc/*
sh lib/init-ssl-ca ssl/acc
sh lib/init-ssl ssl/acc admin kube-admin $ACC_K8S_MASTER
sh lib/init-ssl ssl/acc apiserver kube-apiserver kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local,$ACC_K8S_MASTER $ACC_IPS
sh lib/init-ssl ssl/acc worker kube-worker *.*.compute.internal,*.ec2.internal
openssl dhparam -out ssl/acc/dhparam.pem 2048

# prod
rm -rf ssl/prod/*
sh lib/init-ssl-ca ssl/prod
sh lib/init-ssl ssl/prod admin kube-admin $PROD_K8S_MASTER
sh lib/init-ssl ssl/prod apiserver kube-apiserver kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local,$PROD_K8S_MASTER $PROD_IPS
sh lib/init-ssl ssl/prod worker kube-worker *.*.compute.internal,*.ec2.internal
openssl dhparam -out ssl/prod/dhparam.pem 2048

printf "%s\n" "$(apply_shell_expansion tpl/kubeconfig)" > k8s/kubeconfig

#!/usr/bin/env bash
. lib/functions.sh

VPC_CIDR="10.0.0.1"

IPS="IP.1=127.0.0.1,IP.2=$VPC_CIDR"

# acceptance
rm -rf ssl/acc/*
sh lib/init-ssl-ca ssl/acc
sh lib/init-ssl ssl/acc admin admin $IPS
sh lib/init-ssl ssl/acc api-server api-server $IPS
sh lib/init-ssl ssl/acc worker worker $IPS
openssl dhparam -out ssl/acc/dhparam.pem 2048
rm ssl/acc/*.csr ssl/acc/*.tar ssl/acc/*.cnf ssl/acc/*.srl

# prod
rm -rf ssl/prod/*
sh lib/init-ssl-ca ssl/prod
sh lib/init-ssl ssl/prod admin admin $IPS
sh lib/init-ssl ssl/prod api-server api-server $IPS
sh lib/init-ssl ssl/prod worker worker $IPS
openssl dhparam -out ssl/prod/dhparam.pem 2048
rm ssl/prod/*.csr ssl/prod/*.tar ssl/prod/*.cnf ssl/prod/*.srl

printf "%s\n" "$(apply_shell_expansion tpl/kubeconfig)" > k8s/kubeconfig

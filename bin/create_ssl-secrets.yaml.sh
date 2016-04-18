#!/usr/bin/env bash
set -u
cat > k8s/secrets/$APP_ENV/ssl-secrets.yaml <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: ssl-secrets
  namespace: default
type: Opaque
data:
  htpasswd: '$(echo $HTPASSWD)'
  proxycert: '$(echo $SSL_CERT)'
  proxychain: '$(echo $SSL_CHAIN)'
  proxykey: '$(echo $SSL_KEY)'
  dhparam:  '$(echo $DHPARAM)'
EOF

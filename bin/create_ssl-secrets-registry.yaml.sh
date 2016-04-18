#!/usr/bin/env bash
. lib/functions.sh

set -u
cat > k8s/secrets/$APP_ENV/ssl-secrets-registry.yaml <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: ssl-secrets-registry
  namespace: kube-system
type: Opaque
data:
  htpasswd: '$(echo $REG_HTPASSWD)'
  proxycert: '$(echo $STAR_SSL_CERT)'
  proxykey: '$(echo $SSL_KEY)'
  dhparam:  '$(echo $DHPARAM)'
  nginx.conf: '$(apply_shell_expansion tpl/nginx.conf | base64)'
EOF

#!/usr/bin/env bash
set -u
cat > k8s/secrets/$APP_ENV/api-secrets.yaml <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: api-secrets
type: Opaque
data:
  apisecret: $(echo $API_SECRET | base64)
  mandrillkey: $(echo $MANDRILL_KEY | base64)
EOF

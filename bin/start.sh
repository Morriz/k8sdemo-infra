#!/usr/bin/env bash

if [ -z "$APP_ENV" ]; then
  echo "You need to 'export APP_ENV=(acc|prod)' before running this script"
  exit
fi

CURRENT_CONTEXT=`kubectl config view | grep 'current-context:' | sed -n -e 's/^.*current-context: //p'`

echo "This will run in"
echo $CURRENT_CONTEXT
echo "\nDo you want to continue ?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) exit;;
    esac
done

echo "Creating secrets"
bin/create_api-secrets.yaml.sh
bin/create_ssl-secrets-registry.yaml.sh
[ $APP_ENV == "prod" ] && bin/create_ssl-secrets.yaml.sh

echo "Placing secrets"
kubectl create -f k8s/secrets/$APP_ENV/
kubectl create -f k8s/secrets/

echo "Starting services:"
echo "------------------"

echo "- dashboard"
kubectl create -f k8s/dashboard/

echo "- fluentd-elasticsearch bundle"
kubectl create -f k8s/fluentd-elasticsearch/

echo "- influxdb bundle"
kubectl create -f k8s/influxdb/

echo "- mongo bundle"
kubectl create -f k8s/mongo/$APP_ENV/
kubectl create -f k8s/mongo/

echo "- app bundle"
kubectl create -f k8s/app/$APP_ENV/
kubectl create -f k8s/app/

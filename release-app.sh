#!/bin/bash
TAG=$1
RELEASE_NAME="node-starter-app-release"
export KUBECONFIG=$HOME/.kube/kubeconfig

echo "Starting Tiller..."

helm tiller start-ci
export HELM_HOST=127.0.0.1:44134
result=$(helm ls | grep $RELEASE_NAME) 

if [ $? -ne "0" ]; then 
   echo 'running helm install'
   helm install --timeout 180 --name $RELEASE_NAME --values values-staging.yaml --set image.tag=$TAG ts-node-starter-chart
else
   echo 'running helm upgrade'
   helm upgrade --timeout 180 $RELEASE_NAME --values values-staging.yaml --set image.tag=$TAG ts-node-starter-chart
fi

echo "Stoping Tiller..."
helm tiller stop 

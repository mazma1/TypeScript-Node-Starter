#!/bin/bash
TAG=$1
APP="node-starter-app"

export KUBECONFIG=$HOME/.kube/kubeconfig

echo "Starting Tiller..."

helm tiller start-ci
export HELM_HOST=127.0.0.1:44134

result=$(helm ls | grep $APP) 

if [ $? -ne "0" ]; then 
   helm install --timeout 180 --name $APP --set image.tag=$TAG ts-node-starter-chart
else 
   helm upgrade --timeout 180 $APP --set image.tag=$TAG ts-node-starter-chart
fi

echo "Stoping Tiller..."
helm tiller stop 

#!/usr/bin/env zsh
DASHBOARD_URL="http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login";
SECRET_NAME=$(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')
TOKEN=$(kubectl get secret $SECRET_NAME -n kube-system -o jsonpath="{.data.token}" | base64 --decode)

echo $TOKEN | xclip
echo Auth token copied to clipboard
sleep 1
open $DASHBOARD_URL
kubectl proxy

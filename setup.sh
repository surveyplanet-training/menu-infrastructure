#!/usr/bin/env bash

cd terraform
terraform apply -var-file=vars.tfvars -auto-approve
cd ..

aws eks --region eu-central-1 update-kubeconfig --name menu-test --profile spadmin

kubectl create namespace traefik
kubectl create namespace argocd
kubectl create namespace menu

kubectl apply -f secrets/
helm repo add traefik https://helm.traefik.io/traefik
helm repo update
helm install traefik traefik/traefik --values=manifests/kubernetes-infrastructure/traefik/values.yml -n traefik


kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl apply -f manifests/kubernetes-infrastructure/argocd/
kubectl apply -f manifests/menu/api/ingress.yml

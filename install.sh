#!/usr/bin/env bash
sudo k3d cluster create menu-api --api-port 6550 --agents 1 --k3s-arg "--disable=traefik@server:0" --k3s-arg "--disable=servicelb@server:0"
sudo kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/namespace.yaml
sudo kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/metallb.yaml
sudo kubectl create namespace argocd
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
sudo kubectl apply -f manifests/kubernetes-infrastructure/argocd/argocd-repositories.yml
sudo kubectl apply -f manifests/kubernetes-infrastructure/argocd/kubernetes-infrastructure.yml
sudo kubectl apply -f manifests/kubernetes-infrastructure/argocd/menu.yml

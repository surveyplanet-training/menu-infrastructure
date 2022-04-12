cd terraform
terraform apply -var-file=vars.tfvars -auto-approve
cd ..

aws eks --region us-west-2 update-kubeconfig --name menu-test --profile spadmin

kubectl create namespace traefik

kubectl create namespace argocd

kubectl create namespace menu

kubectl create namespace monitoring

kubectl apply -f secrets/

helm repo add traefik https://helm.traefik.io/traefik

helm repo update

helm install traefik traefik/traefik --values=helm/traefik/values.yml -n traefik

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl apply -f manifests/kubernetes-infrastructure/argocd/

kubectl apply -f manifests/menu/api/ingress.yml

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack --values=helm/kube-prometheus-stack/values.yml -n monitoring

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm upgrade --install loki grafana/loki-stack -n monitoring

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts && helm repo update && helm install ksm prometheus-community/kube-state-metrics --set image.tag=v2.2.0 --namespace monitoring

MANIFEST_URL=https://raw.githubusercontent.com/grafana/agent/v0.23.0/production/kubernetes/agent-bare.yaml NAMESPACE=monitoring /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/grafana/agent/release/production/kubernetes/install-bare.sh)" | kubectl apply -f -

kubectl apply -f manifest/kubernetes-manifests/grafana-agent

kubectl rollout restart deployment/grafana-agent -n monitoring

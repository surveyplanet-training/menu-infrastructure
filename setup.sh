cd terraform
terraform apply -var-file=vars.tfvars --auto-approve

export acm_certificate_arn=$(terraform output -json | jq 'map(.value.acm_certificate_arn) | sort[]')

cd ..

aws eks --region us-west-2 update-kubeconfig --name menu-test --profile spadmin

kubectl create namespace traefik

kubectl create namespace argocd

kubectl create namespace menu

kubectl create namespace monitoring

kubectl apply -f secrets/

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts && helm repo update && helm install ksm prometheus-community/kube-state-metrics --set image.tag=v2.2.0 --namespace monitoring

MANIFEST_URL=https://raw.githubusercontent.com/grafana/agent/v0.23.0/production/kubernetes/agent-bare.yaml NAMESPACE=monitoring /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/grafana/agent/release/production/kubernetes/install-bare.sh)" | kubectl apply -f -

kubectl apply -f manifests/kubernetes-infrastructure/grafana-agent/

kubectl rollout restart deployment/grafana-agent -n monitoring

helm repo add eks https://aws.github.io/eks-charts

helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=menu-test

kubectl apply -f manifests/kubernetes-infrastructure/externalDNS/

yq e -i '.metadata.annotations."alb.ingress.kubernetes.io/certificate-arn" = env(acm_certificate_arn)' manifests/menu/api/ingress.yml

kubectl apply -f manifests/menu/api/

#!/usr/bin/env bash
terraform output -json | jq 'map(.value.acm_certificate_arn) | sort[]'
yq e '.metadata.annotations."alb.ingress.kubernetes.io/certificate-arn" = "test"' manifests/menu/api/ingress.yml

yq e '.metadata.annotations."alb.ingress.kubernetes.io/certificate-arn" = `terraform output -json | jq 'map(.value.acm_certificate_arn)'` ' ../manifests/menu/api/ingress.yml

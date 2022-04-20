locals {
  domain = var.domain

  # Removing trailing dot from domain - just to be sure :)
  domain_name = trimsuffix(local.domain, ".")
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 3.0"

  domain_name = local.domain_name
  zone_id     = data.cloudflare_zone.this.id

  subject_alternative_names = [
    "*.${local.domain_name}",
  ]

  create_route53_records  = false
  validation_record_fqdns = cloudflare_record.validation.*.hostname

  tags = {
    Name = local.domain_name
  }
}

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}
provider "cloudflare" {
  email   = var.cf_email
  api_key = var.cf_api_key
}

resource "cloudflare_record" "validation" {
  count = length(module.acm.distinct_domain_names)

  zone_id = data.cloudflare_zone.this.id
  name    = element(module.acm.validation_domains, count.index)["resource_record_name"]
  type    = element(module.acm.validation_domains, count.index)["resource_record_type"]
  value   = replace(element(module.acm.validation_domains, count.index)["resource_record_value"], "/.$/", "")
  ttl     = 60
  proxied = false

  allow_overwrite = true
}

data "cloudflare_zone" "this" {
  name = local.domain_name
}

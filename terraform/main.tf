module "networking" {
  source    = "./modules/networking"
  namespace = var.namespace
  tags      = var.tags
}

module "eks" {
  source    = "./modules/eks"
  namespace = var.namespace
  vpc       = module.networking.vpc
  tags      = var.tags
}

module "acm" {
  source     = "./modules/acm"
  domain     = var.domain
  cf_email   = var.cf_email
  cf_api_key = var.cf_api_key
}

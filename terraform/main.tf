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

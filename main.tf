# Module for network; This module will create all the neccessary resources for the entire project,
#such as vpc, subnets, gateways and all neccssary things to enable proper connectivity

module "network" {
  source                         = "./modules/network"
  region                         = var.region
  vpc_cidr                       = var.vpc_cidr
  subnet_cidr                    = var.subnet_cidr
  all_ips                        = var.all_ips
  enable_dns_support             = var.enable_dns_support
  enable_dns_hostnames           = var.enable_dns_hostnames
  enable_classiclink             = var.enable_classiclink
  enable_classiclink_dns_support = var.enable_classiclink_dns_support
  resource_tag                   = var.resource_tag
#   max_subnets                    = 10
#   public_subnet_count            = 2
#   private_subnet_count           = 4
#   private_subnets                = [for i in range(1, 8, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
#   public_subnets                 = [for i in range(2, 5, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
#   security_groups                = local.security_groups
}

module "NLB" {
  source            = "./modules/NLB"
  vpc_id            = module.network.vpc_id
  subnet            = module.network.k8s-subnet
}
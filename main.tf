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
}

# the module creates keypair
module "keypair" {
  source          = "./modules/keypair"
}

# The Module creates instances 
module "master-nodes" {
  source        = "./modules/master-nodes"
  region        = var.region
  subnet        = module.network.subnets
  count         = 3
  instance_type = var.instance_type
  ami           = var.ami
  k8s-sg        = module.network.security-group
  private_ip    = element(var.master_ip_list, count.index)

  tags = {
    Name = "master-${count.index}"
  }
}

# the module creates worker-nodes
module "worker-nodes" {
  source        = "./modules/worker-nodes"
  region        = var.region
  subnet        = module.network.subnets
  count         = 3
  instance_type = var.instance_type
  ami           = var.ami
  k8s-sg        = module.network.security-group
  private_ip    = element(var.worker_ip_list, count.index)
  
  tags = {
    Name = "worker-${count.index}"
  }
}

# the module creates network load-balancer
module "network-lb" {
  source         = "./modules/network-lb"
  vpc_id         = module.network.vpc_id
  subnet         = module.network.subnets
  /* count          = 3 */
  /* master_ip_list = var.master_ip_list
  target_id      = element(var.master_ip_list, count.index) */
  resource_tag   = var.resource_tag
}
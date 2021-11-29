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

module "network-lb" {
  source              = "./modules/network-lb"
  vpc_id              = module.network.vpc_id
  subnet              = module.network.subnets
  count               = 3
  master_ip_list      = var.master_ip_list
  target_id           = element(var.master_ip_list, count.index)
  resource_tag        = var.resource_tag
}

# module "key-pair" {
#   source                         = "./modules/key-pair"
#   # key_name   = "name-of-key"
#   # public_key = tls_private_key.this.public_key_openssh
#   resource_tag                   = var.resource_tag

# }

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
  # key_name      = "k8s-cluster-from-ground-up"
  # public_key    = file("~/k8s-cluster-from-ground-up/ssh/k8s-cluster-from-ground-up.id_rsa.pub")
  # key_name        = module.key-pair.public-key

  master          = "master-${count.index}"

  tags = {
    Name = "k8s-cluster-from-ground-up-master-${count.index}"
  }
}


module "worker-nodes" {
  source        = "./modules/worker-nodes"
  region        = var.region
  subnet        = module.network.subnets
  count         = 3
  instance_type = var.instance_type
  ami           = var.ami
  k8s-sg        = module.network.security-group
  private_ip    = element(var.worker_ip_list, count.index)
  # key_name      = "k8s-cluster-from-ground-up"
  # public_key    = file("~/k8s-cluster-from-ground-up/ssh/k8s-cluster-from-ground-up.id_rsa.pub")
  # key_name        = module.key-pair.public-key

  worker          = "worker-${count.index}"

  tags = {
    Name = "k8s-cluster-from-ground-up-worker-${count.index}"
  }
}
# declaring all avaialability zones in AWS available
data "aws_availability_zones" "available-zones" {
  state = "available"
}

# create vpc
resource "aws_vpc" "k8s-terraform" {
  cidr_block                     = var.vpc_cidr
  enable_dns_support             = var.enable_dns_support
  enable_dns_hostnames           = var.enable_dns_hostnames
  enable_classiclink             = var.enable_classiclink
  enable_classiclink_dns_support = var.enable_classiclink_dns_support

  tags = {
    Name = "k8s-cluster-from-ground-up"
  }
}

# create dhcp options
resource "aws_vpc_dhcp_options" "k8s-dhcp-option" {
  # domain_name          = k8s.internal
  domain_name_servers  = ["AmazonProvidedDNS"]

  tags = {
    Name = "k8s-cluster-from-ground-up"
  }
}

# associate dhcp options
resource "aws_vpc_dhcp_options_association" "k8s-dns_resolver" {
  vpc_id          = aws_vpc.k8s-terraform.id
  dhcp_options_id = aws_vpc_dhcp_options.k8s-dhcp-option.id
}
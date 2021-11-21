# declaring all avaialability zones in AWS available
data "aws_availability_zones" "available-zones" {
  state = "available"
}

# create vpc
resource "aws_vpc" "k8s-vpc" {
  cidr_block                     = var.vpc_cidr
  enable_dns_support             = var.enable_dns_support
  enable_dns_hostnames           = var.enable_dns_hostnames
  enable_classiclink             = var.enable_classiclink
  enable_classiclink_dns_support = var.enable_classiclink_dns_support

  tags = {
    Name = var.resource_tag
  }
}

# create dhcp options
resource "aws_vpc_dhcp_options" "k8s-dhcp-option" {
  domain_name          = "${var.region}.compute.internal"
  domain_name_servers  = ["AmazonProvidedDNS"]

  tags = {
    Name = var.resource_tag
  }
}

# associate dhcp options
resource "aws_vpc_dhcp_options_association" "k8s-dns_resolver" {
  vpc_id          = aws_vpc.k8s-vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.k8s-dhcp-option.id
}

# create subnet
resource "aws_subnet" "k8s-subnet" {
  vpc_id     = aws_vpc.k8s-vpc.id
  cidr_block = var.subnet_cidr

  tags = {
    Name = var.resource_tag
  }
}

# create internet gateway and attach to vpc
resource "aws_internet_gateway" "k8s-ig" {
  vpc_id = aws_vpc.k8s-vpc.id
  tags = {
    Name = var.resource_tag
  }
}

# create route table and create route
resource "aws_route_table" "k8s-rtb" {
  vpc_id = aws_vpc.k8s-vpc.id
  
  route {
    cidr_block = var.all_routes
    gateway_id = aws_internet_gateway.k8s-ig.id
  }

  tags = {
    Name = var.resource_tag
  }
}

# associate subnet to the route table
resource "aws_route_table_association" "k8s-association" {
  subnet_id      = aws_subnet.k8s-subnet.id
  route_table_id = aws_route_table.k8s-rtb.id
}
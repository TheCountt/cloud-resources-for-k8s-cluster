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
  domain_name         = "${var.region}.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

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
  vpc_id                  = aws_vpc.k8s-vpc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = var.resource_tag
  }
}

# create service cidr and attach to vpc
resource "aws_vpc_ipv4_cidr_block_association" "service_cidr" {
  vpc_id     = aws_vpc.k8s-vpc.id
  cidr_block = var.service_cidr
}


# create internet gateway and attach to vpc
resource "aws_internet_gateway" "k8s-ig" {
  vpc_id = aws_vpc.k8s-vpc.id
  tags = {
    Name = var.resource_tag
  }
}


# create route table
resource "aws_route_table" "k8s-rtb" {
  vpc_id = aws_vpc.k8s-vpc.id

  tags = {
    Name = var.resource_tag
  }
}

# create route for internet gateway
resource "aws_route" "k8s-internet-gateway" {
  route_table_id         = "${aws_route_table.k8s-rtb.id}"
  destination_cidr_block = var.all_ips
  gateway_id             = "${aws_internet_gateway.k8s-ig.id}"
  depends_on             = [aws_route_table.k8s-rtb]
}


# associate subnet to the route table
resource "aws_route_table_association" "k8s-association" {
  subnet_id      = aws_subnet.k8s-subnet.id
  route_table_id = aws_route_table.k8s-rtb.id
}

/////////////////////////////////////////////////////////////////////////


////////////////////////  SECURITY GROUPS ////////////////////////

resource "aws_security_group" "k8s-sg" {
  name        = "k8s-sg"
  vpc_id      = aws_vpc.k8s-vpc.id
  description = "Creating Inbound Traffic"

  # Create Inbound traffic for SSH from anywhere (Do not do this in production. Limit access ONLY to IPs or CIDR that MUST connect)
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.all_ips]
  }

  # Create ICMP ingress for all types
  ingress {
    description = "ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.all_ips]
  }

  # Create inbound traffic to allow connections to the Kubernetes API Server listening on port 6443
  ingress {
    description = "allow connections to K8s API server"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [var.all_ips]
  }

  # Create inbound traffic to port 10250

  ingress {
    description = "open port 10250"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = [var.all_ips]
  }

  # Create inbound traffic to port 80

  ingress {
    description = "open port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.all_ips]
  }

  # Create Inbound traffic for all communication within the subnet to connect on ports used by the master node(s)
  ingress {
    description = "master nodes"
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = [var.subnet_cidr]
  }

  # Create Inbound traffic for all communication within the subnet to connect on ports used by the worker nodes
  ingress {
    description = "worker nodes"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = [var.subnet_cidr]
  }
///////////////////////////////
  # # Just checking
  #     ingress {
  #       description = "service"
  #       from_port = 0
  #       to_port = 0
  #       protocol = "-1"
  #       cidr_blocks = ["172.32.0.0/16"]
  #     }

  # # Just checking
  #     ingress {
  #       description = "all"
  #       from_port = 0
  #       to_port = 0
  #       protocol = "-1"
  #       cidr_blocks = [var.all_ips]
  #     }
////////////////////////////////
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_ips]
  }

  tags = {
    Name = var.resource_tag
  }
}
region = "us-west-1"

vpc_cidr = "172.31.0.0/16"

subnet_cidr = "172.31.0.0/24"

all_ips = "0.0.0.0/0"

enable_dns_support = "true"

enable_dns_hostnames = "true"

enable_classiclink = "false"

enable_classiclink_dns_support = "false"

resource_tag = "k8s-cluster-from-ground-up"

master_ip_list = ["172.31.0.10", "172.31.0.11", "172.31.0.12"]

worker_ip_list = ["172.31.0.20", "172.31.0.21", "172.31.0.22"]

ami = "ami-09005387a0b4f9a81"

instance_type = "t2.micro"

# account_no = "305311085423"
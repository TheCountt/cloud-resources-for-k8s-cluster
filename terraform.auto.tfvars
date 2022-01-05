region = "us-west-2"

vpc_cidr = "192.168.5.0/24"

subnet_cidr = "192.168.5.0/32"

all_ips = "0.0.0.0/0"

enable_dns_support = "true"

enable_dns_hostnames = "true"

enable_classiclink = "false"

enable_classiclink_dns_support = "false"

resource_tag = "k8s-cluster-from-ground-up"

master_ip_list = ["192.168.5.10", "192.168.5.11", "192.168.5.12"]

worker_ip_list = ["192.168.5.20", "192.168.5.21", "192.168.5.22"]

ami = "ami-0477c9562acb01819"

instance_type = "t2.micro"
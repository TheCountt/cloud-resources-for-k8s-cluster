variable "region" {}

variable "vpc_cidr" {}

variable "subnet_cidr" {}

variable "service_cidr" {}

variable "all_ips" {}

variable "enable_dns_support" {}

variable "enable_dns_hostnames" {}

variable "enable_classiclink" {}

variable "enable_classiclink_dns_support" {}

variable "resource_tag" {}

variable "master_ip_list" {
  description = "targeted ip addresses"
  type        = list(any)
}

variable "worker_ip_list" {
  description = "targeted ip addresses"
  type        = list(any)
}

variable "target_id" {
  default = ["master_ip_list"]
}

variable "instance_type" {}

variable "ami" {}
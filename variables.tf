variable "region" {}

variable "vpc_cidr" {}

variable "subnet_cidr" {}

variable "all_ips" {}

variable "enable_dns_support" {}

variable "enable_dns_hostnames" {}

variable "enable_classiclink" {}

variable "enable_classiclink_dns_support" {}

variable "resource_tag" {}

variable "ip_list" {
  description = "targeted ip addresses"
  type = list
}

variable "target_id" {
    default = ["ip_list"]
}

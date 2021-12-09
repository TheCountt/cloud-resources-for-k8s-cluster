variable "resource_tag" {}

variable "vpc_id" {}

variable "subnet" {}

variable "master_ip_list" {
  default = ["172.31.0.10", "172.31.0.11", "172.31.0.12"]
  description = "targeted ip adddresses"
  type = list
}

# variable "target_id" {}

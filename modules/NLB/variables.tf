variable "resource_tag" {}

variable "vpc_id" {}

variable "subnet" {}

variable "ip_list" {
  description = "targeted ip adddresses"
  type = list
}

variable "target_id" {}

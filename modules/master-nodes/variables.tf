
variable "region" {}

variable "subnet" {}

variable "ami" {}

variable "instance_type" {}

variable "k8s-sg" {}

variable "private_ip" {
    default = ["master_ip_list"]
}

variable "key_name" {
    type = string
    default = "k8s-cluster-from-ground-up"
}

 variable "number_of_master_nodes" {
     default = "3"
 }

 variable "master_ip_list" {
  default = ["172.31.0.10", "172.31.0.11", "172.31.0.12"]
  description = "targeted ip adddresses"
  type = list
}
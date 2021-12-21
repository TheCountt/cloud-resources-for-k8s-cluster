
variable "region" {}

variable "subnet" {}

variable "ami" {}

variable "instance_type" {}

variable "k8s-sg" {}

variable "private_ip" {
    default = ["worker_ip_list"]
}

variable "key_name" {
    type = string
    default = "k8s-cluster-from-ground-up"
}

 variable "number_of_worker_nodes" {
     default = "3"
 }

 variable "worker_ip_list" {
  default = ["172.31.0.20", "172.31.0.21", "172.31.0.22"]
  description = "targeted ip adddresses"
  type = list
}
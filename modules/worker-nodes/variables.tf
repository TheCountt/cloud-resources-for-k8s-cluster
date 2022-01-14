
variable "region" {}

variable "subnet_id" {}

variable "ami" {}

variable "instance_type" {}

variable "k8s-sg" {}


variable "key_name" {
  type    = string
  default = "k8s-cluster-from-ground-up"
}


variable "worker_ip_list" {
  default     = ["172.31.0.20", "172.31.0.21", "172.31.0.22"]
  description = "targeted ip adddresses"
  type        = list(any)
}


variable "pod_routes" {
  type    = list(any)
  default = ["172.20.0.0/24", "172.20.1.0/24", "172.20.2.0/24"]
}


///////////
# not part of code

# variable "private_ip" {
#   default = ["worker_ip_list"]
# }
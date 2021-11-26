# terraform {
#   required_version = ">=0.14.3"
#   required_providers {
#     aws = {
#       source  = "linode/linode"
#       version = "1.13.4"
#     }
#     tls = {
#       source  = "hashicorp/tls"
#       version = "3.0.0"
#     }
#   }
# }


provider "aws" {
  region = var.region
}
# Get list of availability zones
data "aws_availability_zones" "available" {
state = "available"
}

provider "tls" {}
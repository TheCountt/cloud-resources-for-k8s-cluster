# resource "tls_private_key" "k8s-ssh" {
#   algorithm = "RSA"
#   rsa_bits  = "4096"
# }

# resource "aws_key_pair" "k8s-ssh_key" {
#   key_name   = var.resource_tag
#   public_key = tls_private_key.k8s-ssh.public_key_openssh
# }

# resource "local_file" "private_key" {
#   content         = tls_private_key.k8s-ssh.private_key_pem
#   filename        = pathexpand("~/k8s-cluster-from-ground-up/ssh/k8s-ssh_key.pem")
#   file_permission = "0600"
# }

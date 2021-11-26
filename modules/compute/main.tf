resource "tls_private_key" "k8s-ssh" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "aws_key_pair" "k8s-ssh_key" {
  key_name   = var.resource_tag
  public_key = tls_private_key.k8s-ssh.public_key_openssh
}

resource "aws_instance" "k8s-master" {
  # count                       = 3
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet
  source_dest_check            = false
  vpc_security_group_ids      = [var.k8s-sg]
  private_ip                  = var.private_ip
  key_name                    = aws_key_pair.k8s-ssh_key.key_name

  tags = var.tag

#  tags = {
#         Name = "k8s-cluster-from-ground-up-master${count.index}"
#     } 

}

resource "local_file" "private_key" {
  content         = tls_private_key.k8s-ssh.private_key_pem
  filename        = pathexpand("~/ssh/k8s-ssh_key.pem")
  file_permission = "0600"
}



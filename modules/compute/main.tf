resource "tls_private_key" "k8s-ssh" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "aws_key_pair" "k8s-ssh_key" {
  key_name   = var.resource_tag
  public_key = tls_private_key.k8s-ssh.public_key_openssh
}

resource "aws_instance" "k8s-master" {
  ami                         = var.ami
  instance_type               = var.instance_type
  region                      = var.region
  subnet_id                   = var.subnet
  vpc_security_group_ids      = [var.k8s-sg]
  private_ip                  = var.private_ip
  key_name                    = aws_key_pair.k8s-ssh_key.key_name


  tags = merge(
    var.resource_tag,
    {
      Name = format("master", count.index)
    } 
  )

}

resource "local_file" "private_key" {
  content         = tls_private_key.k8s-ssh.private_key_pem
  filename        = pathexpand("~/ssh/${local.ssh_key_name}.pem")
  file_permission = "0600"
}



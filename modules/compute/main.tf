resource "aws_instance" "k8s-master" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet
  source_dest_check            = false
  vpc_security_group_ids      = [var.k8s-sg]
  private_ip                  = var.private_ip
  key_name                    = var.key_name
  user_data                   = filebase64("./modules/compute/master-node.sh")
  tags                        = var.tags
}




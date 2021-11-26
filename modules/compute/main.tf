resource "aws_instance" "k8s-master" {
  # count                       = 3
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet
  source_dest_check            = false
  vpc_security_group_ids      = [var.k8s-sg]
  private_ip                  = var.private_ip
  key_name                    = aws_key_pair.k8s-ssh_key.key_name

  tags = var.tags

#  tags = {
#         Name = "k8s-cluster-from-ground-up-master-${count.index}"
#     } 

}




resource "aws_instance" "k8s-master" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet
  source_dest_check            = false
  vpc_security_group_ids      = [var.k8s-sg]
  private_ip                  = var.private_ip
  associate_public_ip_address = true
  key_name                    = "k8s-cluster-from-ground-up"
  tags                        = var.tags


  root_block_device {

   volume_size           = 8
   volume_type           = "gp3"

  }

  connection {
      type        = "ssh"
      host        = self.public_ip
      user        = var.master
      private_key = file("/home/thecountt/k8s-cluster-from-ground-up/ssh/k8s-cluster-from-ground-up.id_rsa")
      timeout     = "5m"
   }
}




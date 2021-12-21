resource "aws_instance" "k8s-master" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet
  source_dest_check           = false
  count                       = var.number_of_master_nodes
  private_ip                  = element(var.master_ip_list, count.index)
  vpc_security_group_ids      = [var.k8s-sg]
#   private_ip                  = var.private_ip
  associate_public_ip_address = true
  key_name                    = "k8s-cluster-from-ground-up"
  
  root_block_device {

   volume_size           = 8
   volume_type           = "gp3"

  }

  connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("/home/thecountt/k8s-cluster-from-ground-up/ssh/k8s-cluster-from-ground-up.id_rsa")
      timeout     = "5m"
   }

   tags = {
    Name = "k8s-cluster-from-ground-up-master-${count.index}"
   }

}





resource "aws_instance" "k8s-worker" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet
  source_dest_check            = false
  vpc_security_group_ids      = [var.k8s-sg]
  private_ip                  = var.private_ip
  key_name                    = "k8s-cluster-from-ground-up"
  tags                        = var.tags

  connection {
      type        = "ssh"
      host        = self.public_ip
      user        = var.worker
      private_key = file("/home/thecountt/k8s-cluster-from-ground-up/ssh/k8s-cluster-from-ground-up.id_rsa")
      timeout     = "5m"
   }
}
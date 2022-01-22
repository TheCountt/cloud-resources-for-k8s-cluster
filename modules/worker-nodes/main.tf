resource "aws_instance" "k8s-worker" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  source_dest_check           = false
  count                       = length(var.worker_ip_list)
  private_ip                  = element(var.worker_ip_list, count.index)
  vpc_security_group_ids      = [var.k8s-sg]
  associate_public_ip_address = true
  user_data                   = <<-EOT
  #!/bin/bash
  hostname "ip-172-31-0-2${count.index}.us-west-2.compute.internal"
  echo "ip-172-31-0-2${count.index}.us-west-2.compute.internal" > /etc/hostname
  hostnamectl
  EOT

  key_name                    = "k8s-cluster-from-ground-up"

  root_block_device {

    volume_size = 8
    volume_type = "gp3"

  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("~/k8s-cluster-from-ground-up/ssh/k8s-cluster-from-ground-up.id_rsa")
    timeout     = "5m"
  }

  tags = {
    Name = "k8s-cluster-from-ground-up-worker-${count.index}"
  }
}


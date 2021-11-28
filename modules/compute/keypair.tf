resource "aws_key_pair" "k8s-ssh_key" {
  key_name    = var.resource_tag
  public_key  = "${filebase64("~/k8s-cluster-from-ground-up/ssh-new/k8s-cluster-from-ground-up.id_rsa")}"
}
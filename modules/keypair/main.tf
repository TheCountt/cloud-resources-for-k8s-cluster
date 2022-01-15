resource "aws_key_pair" "k8s-ssh_key" {
  key_name   = "k8s-cluster-from-ground-up"
  public_key = file("~/k8s-cluster-from-ground-up/ssh/k8s-cluster-from-ground-up.id_rsa.pub")
  # public_key    = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}
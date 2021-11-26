# output "nanode_ip" {
#   value = linode_instance.ssh_tf.ip_address
# }

output "ssh-key" {
  value = tls_private_key.k8s-ssh.private_key_pem
  description = "the generated ssh key"
}

output "key_name" {
  value       = aws_key_pair.k8s-ssh_key.id
  description = "SSH keypair id"
}
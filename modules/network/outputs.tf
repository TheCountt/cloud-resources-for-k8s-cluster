# output for vpc_id
output "vpc_id" {
  value = aws_vpc.k8s-vpc.id
}
# output for subnets
output "subnets" {
  value       = aws_subnet.k8s-subnet.id
  description = "The public subnet"
}

#output for security group
output "security-group" {
  value = aws_security_group.k8s-sg.id
  description = "k8s security-group"
}
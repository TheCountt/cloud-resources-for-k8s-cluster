# output for vpc_id
output "vpc_id" {
  value = aws_vpc.k8s-vpc.id
  description = "the id of vpc"
}
# output for subnets
output "subnets" {
  value       = aws_subnet.k8s-subnet.id
  description = "The public subnet"
}

#output for routable_id
output "route_table_id" {
  value = aws_route_table.k8s-rtb.id
  description = "the id of main route table"
}

#output for routable
output "route_table" {
  value = aws_route_table.k8s-rtb
  description = "main route table name"
}

#output for security group
output "security-group" {
  value = aws_security_group.k8s-sg.id
  description = "k8s security-group"
}
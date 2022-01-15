# output for vpc_id
output "vpc_id" {
  value       = aws_vpc.k8s-vpc.id
  description = "the id of vpc"
}

#  output for subnet_id
output "subnet_id" {
  value       = aws_subnet.k8s-subnet.id
  description = "id of subnet"
}
#output for routable_id
output "route_table_id" {
  value       = aws_route_table.k8s-rtb.id
  description = "the id of  route table"
}

#output for route_table
output "route_table" {
  value       = aws_route_table.k8s-rtb
  description = "route table name"
}

#output for security group
output "security-group" {
  value       = aws_security_group.k8s-sg.id
  description = "k8s security-group"
}
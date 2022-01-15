output "instance_id_0" {
  value       = aws_instance.k8s-worker[0].id
  description = "The instance id of worker-0"
}

output "instance_id_1" {
  value       = aws_instance.k8s-worker[1].id
  description = "The instance id of worker-1"
}

output "instance_id_2" {
  value       = aws_instance.k8s-worker[2].id
  description = "The instance id of worker-2"
}







//////////////
# Not part of code

# output "instance_ids" {
#   value       = aws_instance.k8s-worker[*].id
#   description = "The instance id of worker-nodes"
# }
output "target_id" {
  value       = ["${element(var.ip_list, count.index)}"]
  description = "The private ip addresses"
}
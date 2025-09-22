output "private_ips" {
  value = aws_instance.this[*].private_ip
}


output "instance_ids" {
  description = "List of all EC2 instance IDs"
  value       = aws_instance.this[*].id
}

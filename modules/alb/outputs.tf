output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "sg_id" {
  value = aws_security_group.this.id
}

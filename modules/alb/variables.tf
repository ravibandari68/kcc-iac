variable "name" {
  description = "Name prefix for ALB resources (Load Balancer, Target Group, Listener)"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the ALB and Target Group will be created"
  type        = string
}

variable "internal_alb" {
    description = "private or public load balancerå"
    type = string
    default = false
}
variable "subnet_ids" {
  description = "List of subnet IDs to associate with the ALB (should be from at least 2 AZs for HA)"
  type        = list(string)
}

variable "app_port" {
  description = "Port on which the target instances (EC2) are listening (default: 80)"
  type        = number
  default     = 80
}

variable "target_ids" {
  description = "List of target IDs (usually EC2 instance IDs) to register with the Target Group"
  type        = list(string)
}

variable "tags" {
  description = "Additional tags to associate with ALB resources"
  type        = map(string)
  default     = {}
}


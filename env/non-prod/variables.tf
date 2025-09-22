##########################
# VPC module variables
##########################

variable "vpc_name" {
  description = "Name prefix for the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "List of availability zones for subnets"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to the VPC and subnets"
  type        = map(string)
  default     = {}
}


##########################
# EC2 module variables
##########################

variable "ec2_name" {
  description = "Name prefix for EC2 instances"
  type        = string
}

variable "ec2_ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ssh_cidr" {
  description = "CIDR block allowed to SSH into EC2"
  type        = string
  default     = "1.2.3.4/32"
}

variable "app_port" {
  description = "Application port that ALB will target"
  type        = number
  default     = 80
}

variable "ec2_instance_count" {
  description = "Number of EC2 instances to launch"
  type        = number
  default     = 2
}

variable "ec2_ingress_rules" {
  description = "Ingress rules for EC2 security group"
  type        = list(object({
    description     = string
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string))
    security_groups = optional(list(string))
  }))
  default = []
}

variable "ec2_egress_rules" {
  description = "Egress rules for EC2 security group"
  type        = list(object({
    description     = string
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string))
    security_groups = optional(list(string))
  }))
  default = []
}

variable "ec2_user_data" {
  description = "Startup script (template) for EC2 instance"
  type        = string
  default     = ""
}

variable "iam_policies" {
  description = "Name of the IAM policies"
}


##########################
# ALB module variables
##########################

variable "alb_name" {
  description = "Name of the ALB"
  type        = string
}




##########################
# ECR variables
##########################


variable "ecr_repository_names" {
  description = "List of ECR repository names to create"
  type        = list(string)
}




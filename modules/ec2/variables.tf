variable "name" {
  description = "Name prefix for resources (e.g., EC2 instance, SG, IAM role)"
  type        = string
}

variable "instance_count" {
  description = "Number of EC2 instances to launch"
  type        = number
  default     = 2
}


variable "vpc_id" {
  description = "The ID of the VPC where the EC2 instance and security groups will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where the EC2 instance can be launched (first one will be used)"
  type        = list(string)
}

variable "assign_static_ip" {
  type    = bool
  default = false
}

variable "eip_domain" {
  default = "vpc"
  type = string
}

variable "ami_id" {
  description = "AMI ID to use for the EC2 instance (e.g., Ubuntu or Amazon Linux 2)"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance (default: t3.micro)"
  type        = string
  default     = "t3.micro"
}


variable "app_port" {
  description = "Application port to expose on the EC2 instance and allow from ALB"
  type        = number
  default     = 80
}

variable "tags" {
  description = "Additional tags to associate with resources"
  type        = map(string)
  default     = {}
}

variable "user_data" {
  description = "Startup script for EC2 instance (use templatefile() for dynamic values like port and image)"
  type        = string
  default     = ""
}



# List of ingress rules to allow
variable "ingress_rules" {
  description = <<EOT
List of ingress rules. Each rule is an object with:

EOT
  type = list(object({
    description     = string
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string), [])
    security_groups = optional(list(string), [])
  }))
  default = []
}

# Egress rules
variable "egress_rules" {
  description = "List of egress rules (same structure as ingress)."
  type = list(object({
    description     = string
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string), [])
    security_groups = optional(list(string), [])
  }))
  default = [
    {
      description     = "Allow all outbound"
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      cidr_blocks     = ["0.0.0.0/0"]
      security_groups = []
    }
  ]
}


variable "iam_policies" {
  description = "Name of the IAM policies"
}

variable "ssh_key_pair" {
  type        = string
  description = "SSH key pair to be provisioned on the instance"
  default     = null
}

variable "root_block_device_encrypted" {
  type        = bool
  default     = true
  description = "Whether to encrypt the root block device"
}

variable "root_block_device_kms_key_id" {
  type        = string
  default     = null
  description = "KMS key ID used to encrypt EBS volume. When specifying root_block_device_kms_key_id, root_block_device_encrypted needs to be set to true"
}


variable "ebs_volume_encrypted" {
  type        = bool
  description = "Whether to encrypt the additional EBS volumes"
  default     = true
}

variable "kms_key_id" {
  type        = string
  default     = null
  description = "KMS key ID used to encrypt EBS volume. When specifying kms_key_id, ebs_volume_encrypted needs to be set to true"
}


variable "force_detach_ebs" {
  type        = bool
  default     = false
  description = "force the volume/s to detach from the instance."
}

variable "ebs_volume_count" {
  type        = number
  description = "Count of EBS volumes that will be attached to the instance"
  default     = 0
}

variable "root_volume_size" {
  type        = number
  description = "Size of the root volume in gigabytes"
  default     = 50

}
variable "root_volume_type" {
  type        = string
  description = "Type of root volume. Can be standard, gp2, gp3, io1 or io2"
  default     = "gp2"
}

variable "root_iops" {
  type        = number
  description = "Amount of provisioned IOPS. This must be set if root_volume_type is set of `io1`, `io2` or `gp3`"
  default     = 0
}
variable "root_throughput" {
  type        = number
  description = "Amount of throughput. This must be set if root_volume_type is set to `gp3`"
  default     = 0
}

variable "availability_zone" {
  type        = string
  description = "Availability Zone the instance is launched in. If not set, will be launched in the first AZ of the region"
  default     = ""
}

variable "ebs_volume_size" {
  type        = number
  description = "Size of the additional EBS volumes in gigabytes"
  default     = 10
}
variable "ebs_iops" {
  type        = number
  description = "Amount of provisioned IOPS. This must be set with a volume_type of `io1`, `io2` or `gp3`"
  default     = 0
}

variable "ebs_volume_type" {
  type        = string
  description = "The type of the additional EBS volumes. Can be standard, gp2, gp3, io1 or io2"
  default     = "gp2"
}

variable "ebs_throughput" {
  type        = number
  description = "Amount of throughput. This must be set if volume_type is set to `gp3`"
  default     = 0
}

variable "delete_on_termination" {
  type        = bool
  description = "Whether the volume should be destroyed on instance termination"
  default     = true
}

variable "stop_ec2_before_detaching_vol" {
  type        = bool
  default     = false
  description = "Set this to true to ensure that the target instance is stopped before trying to detach the volume/s."
}

variable "ebs_device_name" {
  type        = list(string)
  description = "Name of the EBS device to mount"
  default     = ["/dev/xvdb", "/dev/xvdc", "/dev/xvdd", "/dev/xvde", "/dev/xvdf", "/dev/xvdg", "/dev/xvdh", "/dev/xvdi", "/dev/xvdj", "/dev/xvdk", "/dev/xvdl", "/dev/xvdm", "/dev/xvdn", "/dev/xvdo", "/dev/xvdp", "/dev/xvdq", "/dev/xvdr", "/dev/xvds", "/dev/xvdt", "/dev/xvdu", "/dev/xvdv", "/dev/xvdw", "/dev/xvdx", "/dev/xvdy", "/dev/xvdz"]
}
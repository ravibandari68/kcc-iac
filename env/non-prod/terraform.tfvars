# VPC module inputs
vpc_name         = "myapp"
vpc_cidr         = "10.0.0.0/16"
azs              = ["us-east-1a", "us-east-1b", "us-east-1c"]
public_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
#private_subnets  = ["10.0.11.0/24", "10.0.12.0/24"]
tags = {
  Project = "demo"
  Env     = "nprod"
}

# EC2 module inputs
ec2_name          = "myapp-ec2"
ec2_ami_id        = "ami-08982f1c5bf93d976"
ec2_instance_count = 1
iam_policies = [
  "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
  "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
  "arn:aws:iam::aws:policy/AmazonSSMFullAccess",
  "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
]
ec2_ingress_rules = [
  {
    description     = "Allow ALB to access app port"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks = ["105.276.161.29/32"] #change_me
    
  },
  {
    description = "Allow SSH from admin IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"] #change_me
  }
]
#change_me
ec2_egress_rules = [                            
  {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
]

# ALB module inputs
alb_name       = "myapp-alb"
    

# ECR module inputs
ecr_repository_names = ["myapp"]

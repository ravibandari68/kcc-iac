locals {
  ec2_user_data = templatefile("./startups/ec2_startup.tpl", {
    app_port     = 5000
    host_port    = 80
    docker_image = "934192905430.dkr.ecr.us-east-1.amazonaws.com/myapp:latest"
  })
}

## Layer-0###
##################### VPC #####################
# module "vpc" {
#   source          = "../../modules/vpc"
#   name            = var.vpc_name
#   vpc_cidr        = var.vpc_cidr
#   azs             = var.azs
#   public_subnets  = var.public_subnets
#   private_subnets = var.private_subnets
#   tags            = var.tags
# }

## Layer-1###
##################### EC2 #####################
# module "ec2" {
#   source           = "../../modules/ec2"
#  availability_zone   = var.azs[0]
#   name             = var.ec2_name
#   vpc_id           = module.vpc.vpc_id
#   subnet_ids       = module.vpc.public_subnet_ids
#   ami_id           = var.ec2_ami_id
#   user_data        = local.ec2_user_data
#   instance_count   = var.ec2_instance_count
#   ingress_rules    = var.ec2_ingress_rules
#   egress_rules     = var.ec2_egress_rules
# iam_policies = var.iam_policies
# assign_static_ip = true

# }
##################### ECR #####################
#  module "ecr" {
#   source = "../../modules/ecr"
#   repository_names     = var.ecr_repository_names
#   image_tag_mutability = "MUTABLE"
#   scan_on_push         = true
#   tags = var.tags

# }

##################### ALB #####################

# module "alb" {
#   source      = "../modules/alb"
#   name        = var.alb_name
#   vpc_id      = module.vpc.vpc_id
#   subnet_ids  = module.vpc.private_subnet_ids
#   target_ids  = module.ec2.instance_ids
# }


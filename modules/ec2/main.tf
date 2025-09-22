locals {
 volume_count   = var.ebs_volume_count > 0 && var.instance_count > 0 ? var.ebs_volume_count : 0
 root_iops              = contains(["io1", "io2", "gp3"], var.root_volume_type) ? var.root_iops : null
 root_throughput        = var.root_volume_type == "gp3" ? var.root_throughput : null
 ebs_iops               = contains(["io1", "io2", "gp3"], var.ebs_volume_type) ? var.ebs_iops : null
 ebs_throughput         = var.ebs_volume_type == "gp3" ? var.ebs_throughput : null
}

resource "aws_security_group" "this" {
  name        = "${var.name}-ec2-sg"
  description = "Dynamic EC2 Security Group"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description     = ingress.value.description
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      cidr_blocks     = lookup(ingress.value, "cidr_blocks", [])
      security_groups = lookup(ingress.value, "security_groups", [])
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      description     = egress.value.description
      from_port       = egress.value.from_port
      to_port         = egress.value.to_port
      protocol        = egress.value.protocol
      cidr_blocks     = lookup(egress.value, "cidr_blocks", [])
      security_groups = lookup(egress.value, "security_groups", [])
    }
  }
}


# Create an EC2 role
resource "aws_iam_role" "ec2_role" {
  name = "${var.name}-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

# Attach pre-created IAM policies dynamically
resource "aws_iam_role_policy_attachment" "ec2_policies" {
  for_each  = toset(var.iam_policies)
  role      = aws_iam_role.ec2_role.name
  policy_arn = each.value
}

# Create an instance profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.name}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}


resource "random_string" "ec2_postfix" {
  count    = var.instance_count
  length   = 4      
  upper    = false
  lower    = true
  numeric  = false
  special  = false
}

resource "aws_instance" "this" {
  count                  = var.instance_count
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = element(var.subnet_ids, count.index % length(var.subnet_ids))
  vpc_security_group_ids = [aws_security_group.this.id]
  user_data              = var.user_data
  key_name                             = var.ssh_key_pair
iam_instance_profile= aws_iam_instance_profile.ec2_profile.name
  tags = merge(
    var.tags,
    {
      Name = "${var.name}-${random_string.ec2_postfix[count.index].result}"
    }
  )
 root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    iops                  = local.root_iops
    throughput            = local.root_throughput
    delete_on_termination = var.delete_on_termination
    encrypted             = var.root_block_device_encrypted
    kms_key_id            = var.root_block_device_kms_key_id
  } 
}
# Create Elastic IPs only if assign_static_ip is true
resource "aws_eip" "this" {
  count = var.assign_static_ip ? var.instance_count : 0
  domain = var.eip_domain

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-${count.index}-eip"
    }
  )
}

# Associate Elastic IPs with the instances
resource "aws_eip_association" "this" {
  count = var.assign_static_ip ? var.instance_count : 0

  instance_id   = aws_instance.this[count.index].id
  allocation_id = aws_eip.this[count.index].id
}
resource "aws_ebs_volume" "default" {
  count             = local.volume_count
  availability_zone                    = var.availability_zone
  size              = var.ebs_volume_size
  iops              = local.ebs_iops
  throughput        = local.ebs_throughput
  type              = var.ebs_volume_type
  encrypted         = var.ebs_volume_encrypted
  kms_key_id        = var.kms_key_id
}

resource "aws_volume_attachment" "default" {
  count                          = local.volume_count
  device_name                    = var.ebs_device_name[count.index]
  volume_id                      = aws_ebs_volume.default[count.index].id
  instance_id                    = one(aws_instance.this[*].id)
  force_detach                   = var.force_detach_ebs
  stop_instance_before_detaching = var.stop_ec2_before_detaching_vol
}


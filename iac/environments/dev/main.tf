# ==============================================================================
# PROVIDER
# ==============================================================================
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.tags
  }
}

# ==============================================================================
# AMI — Latest Ubuntu 22.04 LTS (amd64)
# ==============================================================================
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ==============================================================================
# NETWORKING — VPC Module
# ==============================================================================
module "vpc" {
  source = "../../modules/vpc"

  name                 = var.vpc_name
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = true
  tags                 = var.tags
}

# ==============================================================================
# SECURITY GROUP — Basic internet access
# ==============================================================================
resource "aws_security_group" "web_sg" {
  name        = "dev-web-sg"
  description = "Allow inbound SSH from anywhere + outbound internet"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ Name = "dev-web-sg" }, var.tags)
}

# ==============================================================================
# COMPUTE — EC2 Instance Module
# ==============================================================================
module "ec2_instance" {
  source = "../../modules/ec2-instance"

  name                        = var.instance_name
  ami_id                      = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = module.vpc.public_subnet_ids[0]
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  root_volume_size            = var.root_volume_size
  root_volume_type            = var.root_volume_type
  user_data                   = null # will be an Ansible bootstrap later
  tags                        = var.tags
}
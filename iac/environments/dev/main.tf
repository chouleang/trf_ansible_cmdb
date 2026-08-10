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
  owners      = ["099720109477"]

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
# SSH KEY PAIR — Terraform generated
# ==============================================================================
module "key_pair" {
  source   = "../../modules/key-pair"
  key_name = "${var.vpc_name}-key"
}

# ==============================================================================
# SECURITY GROUPS
# ==============================================================================

# --- Controller SG: SSH from your IP ---
resource "aws_security_group" "controller_sg" {
  name        = "dev-controller-sg"
  description = "Ansible controller — SSH inbound"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH from anywhere (lock to your IP later)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound (SSH to target + apt installs)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ Name = "dev-controller-sg" }, var.tags)
}

# --- Web SG: SSH from controller only + HTTP from anywhere ---
resource "aws_security_group" "web_sg" {
  name        = "dev-web-sg"
  description = "Web server — SSH from controller only + HTTP public"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "SSH from Ansible controller only"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.controller_sg.id]
  }

  ingress {
    description = "HTTP — Nginx"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ Name = "dev-web-sg" }, var.tags)
}

# ==============================================================================
# COMPUTE
# ==============================================================================

# --- Ansible Controller ---
module "controller" {
  source = "../../modules/ec2-instance"

  name                        = var.controller_name
  ami_id                      = data.aws_ami.ubuntu.id
  instance_type               = var.controller_instance_type
  key_name                    = var.key_name
  subnet_id                   = module.vpc.public_subnet_ids[0]
  vpc_security_group_ids      = [aws_security_group.controller_sg.id]
  associate_public_ip_address = true
  root_volume_size            = 20
  root_volume_type            = "gp3"
  user_data                   = templatefile("${path.root}/templates/user_data_controller.sh.tpl", {
    target_ip   = module.web.private_ip
    private_key = module.key_pair.private_key_pem
  })
  tags = merge({ Role = "ansible-controller" }, var.tags)
}

# --- Web Server (Target) ---
module "web" {
  source = "../../modules/ec2-instance"

  name                        = var.instance_name
  ami_id                      = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = module.key_pair.key_name
  subnet_id                   = module.vpc.public_subnet_ids[1]
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  root_volume_size            = var.root_volume_size
  root_volume_type            = var.root_volume_type
  user_data                   = null
  tags = merge({ Role = "web-server" }, var.tags)
}
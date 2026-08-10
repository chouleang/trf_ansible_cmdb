# ==============================================================================
# REGION
# ==============================================================================
variable "aws_region" {
  description = "AWS region for dev resources"
  type        = string
  default     = "us-east-1"
}

# ==============================================================================
# VPC
# ==============================================================================
variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
  default     = "dev-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for the dev VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "azs" {
  description = "Availability zones to use"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs"
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs"
  type        = list(string)
  default     = ["10.10.11.0/24", "10.10.12.0/24"]
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway (disabled for dev to save cost)"
  type        = bool
  default     = false
}

# ==============================================================================
# EC2
# ==============================================================================
variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "dev-web-server"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of the existing EC2 key pair"
  type        = string
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 20
}

variable "root_volume_type" {
  description = "Root EBS volume type"
  type        = string
  default     = "gp3"
}

# ==============================================================================
# TAGS
# ==============================================================================
variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "trf-ansible-cmdb"
    ManagedBy   = "terraform"
  }
}

# ==============================================================================
# ANSIBLE CONTROLLER
# ==============================================================================
variable "controller_name" {
  description = "Name tag for the Ansible controller EC2 instance"
  type        = string
  default     = "dev-ansible-controller"
} 
variable "controller_instance_type" {
  description = "EC2 instance type for the Ansible controller"
  type        = string
  default     = "t3.micro"
}

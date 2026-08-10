# ==============================================================================
# VPC OUTPUTS
# ==============================================================================
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "VPC CIDR"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

# ==============================================================================
# EC2 OUTPUTS
# ==============================================================================
output "controller_instance_id" {
  description = "EC2 instance ID"
  value       = module.controller.instance_id
}
output "controller_instance_public_ip" {
  description = "Public IP — SSH with: ssh -i <your-key.pem> ubuntu@<this-ip>"
  value       = module.controller.public_ip
}
output "instance_id" {
  description = "EC2 instance ID"
  value       = module.web.instance_id
}

output "instance_public_ip" {
  description = "Public IP — SSH with: ssh -i <your-key.pem> ubuntu@<this-ip>"
  value       = module.web.public_ip
}

output "instance_private_ip" {
  description = "Private IP"
  value       = module.web.private_ip
}

output "instance_arn" {
  description = "EC2 instance ARN"
  value       = module.web.arn
}
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
output "instance_id" {
  description = "EC2 instance ID"
  value       = module.ec2_instance.id
}

output "instance_public_ip" {
  description = "Public IP — SSH with: ssh -i <key> ubuntu@<this_ip>"
  value       = module.ec2_instance.public_ip
}

output "instance_private_ip" {
  description = "Private IP"
  value       = module.ec2_instance.private_ip
}

output "instance_arn" {
  description = "EC2 instance ARN"
  value       = module.ec2_instance.arn
}
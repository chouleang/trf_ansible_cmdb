output "id" {
  description = "Instance ID"
  value = module.ec2_instance.id
}
output "public_ip" {
  description = "Public IP address of the instance"
  value = module.ec2_instance.public_ip
}
output "private_ip" {
  description = "Private IP address of the instance"
    value = module.ec2_instance.private_ip
}
output "arn" {
  description = "ARN of the instance"
  value = module.ec2_instance.arn
}
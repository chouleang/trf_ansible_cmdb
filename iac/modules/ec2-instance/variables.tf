variable "name" {
  description = "The name of the EC2 instance"
  type        = string
}
variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
}
variable "instance_type" {
  description = "The type of the EC2 instance"
  type        = string
}
variable "subnet_id" {
  description = "The subnet ID where the EC2 instance will be launched"
  type        = string
}
variable "vpc_security_group_ids" {
    description = "List of VPC security group IDs to associate with the EC2 instance"
    type        = list(string)
}
variable "key_name" {
  description = "The name of the key pair to use for the EC2 instance"
  type        = string
}
variable "tags" {
  description = "A map of tags to assign to the EC2 instance"
  type        = map(string)
  default     = {}      
}
variable "user_data" {
  description = "The user data to provide when launching the EC2 instance"
  type        = string
  default     = null
}
variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the EC2 instance"
  type        = bool
  default     = true
}
variable "root_volume_size" {
  description = "The size of the root volume in GB"
  type        = number
  default     = 20
}
variable "root_volume_type" {
  description = "The type of the root volume"
  type        = string
  default     = "gp3"
}
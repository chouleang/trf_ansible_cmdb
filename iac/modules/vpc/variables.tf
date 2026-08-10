variable "name" {
  description = "Name prefix for the vpc"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "List of availability zones to use for the subnets"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for the public subnets"
  type        = list(string)
}
variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for the private subnets"
  type        = list(string)
}
variable "enable_nat_gateway" {
  description = "Whether to create NAT Gateways for private subnet outbound"
  type        = bool
  default     = false
}
variable "single_nat_gateway" {
  description = "If enable_nat_gateway is true: Use ONE share Nat Gateway for all private subnets"
  type        = bool
  default     = true
}
variable "tags" {
  description = "A map of tags to add to vpc"
  type        = map(string)
  default     = {}
}
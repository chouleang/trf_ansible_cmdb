module "vpc" {
  source                  = "terraform-aws-modules/vpc/aws"
  version                 = "~>5.13.0"
  name                    = var.name
  cidr                    = var.vpc_cidr
  azs                     = var.azs
  public_subnets          = var.public_subnet_cidrs
  map_public_ip_on_launch = true
  enable_dns_hostnames    = true
  enable_dns_support      = true
  private_subnets         = var.private_subnet_cidrs
  enable_nat_gateway      = var.enable_nat_gateway
  single_nat_gateway      = var.single_nat_gateway
  tags                    = merge({ "Name" = var.name }, var.tags)
  public_subnet_tags      = merge({ "Name" = "${var.name}-public" }, { "Tier" = "public" }, var.tags)
  private_subnet_tags     = merge({ "Name" = "${var.name}-private" }, { "Tier" = "private" }, var.tags)

}
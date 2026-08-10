module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"
  version = "5.7.0"

  name = var.name
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  associate_public_ip_address = var.associate_public_ip_address
  root_block_device = [
    {
        volume_size = var.root_volume_size
        volume_type = var.root_volume_type
    }
  ]
  user_data = var.user_data
  tags = merge(
    {
        Name = var.name
    },
    var.tags
  )
}
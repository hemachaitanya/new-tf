resource "aws_instance" "ec2_public" {
  count = var.instance_info_public != null ? 1 : 0
  ami                         = var.instance_info_public.ami
  instance_type               = var.instance_info_public.size
  associate_public_ip_address = var.instance_info_public.associate_public_ip_address
  key_name                    = var.instance_info_public.key_name
  subnet_id                   = var.instance_info_public.subnet_id
  vpc_security_group_ids = [
    var.instance_info_public.security_group_id
  ]
  tags = {
    Name = var.instance_info_public.name
  }
}

resource "aws_instance" "ec2_private" {
  count = var.instance_info_private != null ? 1 : 0
  ami                         = var.instance_info_private.ami
  instance_type               = var.instance_info_private.size
  associate_public_ip_address = var.instance_info_private.associate_public_ip_address
  key_name                    = var.instance_info_private.key_name
  subnet_id                   = var.instance_info_private.subnet_id
  vpc_security_group_ids = [
    var.instance_info_private.security_group_id
  ]
  tags = {
    Name = var.instance_info_private.name
  }
}
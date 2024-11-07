output "region_1_public_ip" {
  value = aws_instance.ec2_public[*].public_ip
}

output "public_instance_information" {
  value = aws_instance.ec2_public
}

output "region_2_public_ip" {
  value = aws_instance.ec2_private[*].public_ip
}

output "priavte_instance_information" {
  value = aws_instance.ec2_public
}

output "public_instance_id" {
  value = length(aws_instance.ec2_public) > 0 ? aws_instance.ec2_public[0].id : null
}

output "private_instance_id" {
  value = length(aws_instance.ec2_private) > 0 ? aws_instance.ec2_private[0].id : null
}
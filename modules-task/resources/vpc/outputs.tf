output "igw_vpc_id" {
    value = aws_vpc.public.id
}

output "nat_vpc_id" {
    value = aws_vpc.private.id
}

output "public_subnets_igw" {
    value = aws_subnet.public_subnet_az.*.id
}

output "public_subnets_nat" {
    value = aws_subnet.public_subnet_az1.*.id
}

output "private_subnets_nat" {
    value = aws_subnet.private_subnet_az2.*.id
}
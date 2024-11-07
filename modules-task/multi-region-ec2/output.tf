output "vpc_east1_id" {
  value = module.vpc.igw_vpc_id
}
output "vpc_east2_id" {
  value = module.vpc.nat_vpc_id
}

output "public_subnets_east1" {
  value = module.vpc.public_subnets_igw
}

output "public_subnets_east2" {
  value = module.vpc.public_subnets_nat
}


output "private_subnets_east2" {
  value = module.vpc.private_subnets_nat
}
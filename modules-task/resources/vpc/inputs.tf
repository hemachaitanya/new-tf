variable "network_info" {
  type = object({
    public_vpc_info = object({
      vpc_tags              = string
      vpc_cidr_block        = string
      subnet_cidr_block     = string
      subnet_tags           = string
      availability_zone     = string
    })
    private_vpc_info = object({
      vpc_tags              = string
      vpc_cidr_block        = string
      subnet_cidr_block     = list(string)
      subnet_tags           = list(string)
      availability_zones    = list(string)
    })
  })
}

variable "provider_info" {
  type = object({
    region_useast1 = string
    region_useast2 = string 
  })
}
variable "provier_information" {
  type = object({
     useast1_region_name = string
     useast2_region_name = string
  })
  default = {
    useast1_region_name = "us-east-1"
    useast2_region_name = "us-east-2"
  }
}

variable "key_pair_info" {
  type = object({
    region_1 = string
    region_2 = string
  })
  default = {
    region_1 = "~/.ssh/id_rsa.pub"
    region_2 = "~/.ssh/id_rsa.pub"
  }
}
variable "instance_info_public" {
  type = object({
    name                        = string
    size                        = string
    ami                         = string
    subnet_id                   = string
    security_group_id           = string
    key_name                    = string
    associate_public_ip_address = bool
  })
  default = null
}

variable "instance_info_private" {
  type = object({
    name                        = string
    size                        = string
    ami                         = string
    subnet_id                   = string
    security_group_id           = string
    key_name                    = string
    associate_public_ip_address = bool
  })
  default = null
}
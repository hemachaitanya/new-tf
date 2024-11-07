module "vpc" {
  source = "github.com/batchusivaji/terraform/modules/resources/vpc"
  provider_info = {
    region_useast1 = "ap-northeast-1"
    region_useast2 = "ap-northeast-2"
  }
  network_info = {
    public_vpc_info = {
      vpc_tags              = "public-vpc"
      vpc_cidr_block        = "10.0.0.0/16"
      subnet_cidr_block     = "10.0.1.0/24"
      subnet_tags           = "public-subnet"
      availability_zone     = "ap-northeast-1a"
    }
    private_vpc_info = {
      vpc_tags              = "private-vpc"
      vpc_cidr_block        = "10.1.0.0/16"
      subnet_cidr_block     = ["10.1.1.0/24", "10.1.2.0/24"]
      subnet_tags           = ["public-subnet-1", "private-subnet-1"]
      availability_zones    = ["ap-northeast-2a", "ap-northeast-2c"]
    }
  }
}
provider "aws" {
  alias  = "us_east_1"
  region = "ap-northeast-1"
}

provider "aws" {
  alias  = "us_east_2"
  region = "ap-northeast-2"
}

# # fetch the vpc's,subnet's
# data "aws_ami" "amazon_us_east_2" {
#    provider    = aws.us_east_2
#    most_recent = true
#    owners      = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm-*-x86_64-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
# }

# data "aws_subnets" "us_east_1_subnets" {
#   provider = aws.us_east_1
#   filter {
#     name   = "tag:Name"
#     values = ["public-subnet"]
#   }
# }

# data "aws_vpc" "us_east_2_vpc" {
#   provider = aws.us_east_2
#   filter {
#     name   = "tag:Name"
#     values = ["private-vpc"]
#   }
# }

# data "aws_subnets" "us_east_2_subnets" {
#   provider = aws.us_east_2
#   filter {
#     name   = "tag:Name"
#     values = ["public-subnet-1", "private-subnet-1"]
#   }
# }


# Create public security group
module "public_security_group" {
  source    = "github.com/batchusivaji/terraform/modules/resources/security_group/"
  providers = { aws = aws.us_east_1 }
  security_group_info = {
    description       = "open 22 and 80 port within vpc"
    name              = "public-sg"
    region            = "ap-northeast-1"
    vpc_id            = module.vpc.igw_vpc_id
    inbound_rules     = [{
      cidr            = "0.0.0.0/0"
      port            = 22
      protocol        = "tcp"
      description     = "open ssh"
      },
      {
        cidr          = "0.0.0.0/0"
        port          = 80
        protocol      = "tcp"
        description   = "open http"
      }
    ]
    outbound_rules    = []
    allow_all_egress  = true
  }

  depends_on = [module.vpc]
}

# Create a private security group to open port 22 within the VPC
module "private_security_group" {
  source    = "github.com/batchusivaji/terraform/modules/resources/security_group/"
  providers = { aws = aws.us_east_2 }
  security_group_info = {
    name              = "private-sg"
    description       = "open 22 port within vpc"
    vpc_id            = module.vpc.nat_vpc_id
    allow_all_egress  = true
    outbound_rules    = []
    inbound_rules     = [{
      cidr            = "192.168.0.0/16"
      port            = 22
      protocol        = "tcp"
      description     = "open 22 port"
    }]
  }
  depends_on = [ module.vpc ]
}



data "aws_ami" "amazon_us_east_1" {
   provider    = aws.us_east_1
   most_recent = true
   owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "amazon_us_east_2" {
   provider    = aws.us_east_2
   most_recent = true
   owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "instances_us_east_1" {
  source    = "github.com/batchusivaji/terraform/modules/resources/ec2"
  providers = { aws = aws.us_east_1 }

  instance_info_public = {
    name                        = "public-ec2"
    ami                         = data.aws_ami.amazon_us_east_1.id
    size                        = "t2.micro"
    key_name                    = aws_key_pair.my_key_pair_region_1.key_name
    subnet_id                   = module.vpc.public_subnets_igw[0]
    associate_public_ip_address = true
    security_group_id           = module.public_security_group.security_group_id
  }
  
  instance_info_private = null

  depends_on = [module.public_security_group, module.vpc]
}

module "instances_us_east_2" {
  source    = "github.com/batchusivaji/terraform/modules/resources/ec2"
  providers = { aws = aws.us_east_2 }

  instance_info_private = {
    name                        = "private-ec2"
    ami                         = data.aws_ami.amazon_us_east_2.id
    size                        = "t2.micro"
    key_name                    = aws_key_pair.my_key_pair_region_2.key_name
    subnet_id                   = module.vpc.private_subnets_nat[0]
    associate_public_ip_address = true
    security_group_id           = module.private_security_group.security_group_id
  }
  instance_info_public = null
}
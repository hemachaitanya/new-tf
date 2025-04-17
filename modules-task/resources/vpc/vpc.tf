terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.52.0"
    }
  }
}
provider "aws" {
  alias  = "useast1"
  region = var.provider_info.region_useast1
}
provider "aws" {
  alias  = "useast2"
  region = var.provider_info.region_useast2
}
# Create VPC
resource "aws_vpc" "public" {
  provider = aws.useast1
  cidr_block           = var.network_info.public_vpc_info.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.network_info.public_vpc_info.vpc_tags
  }
}

resource "aws_vpc" "private" {
  provider = aws.useast2
  cidr_block           = var.network_info.private_vpc_info.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.network_info.private_vpc_info.vpc_tags
  }
}

# Create Public Subnet AZ
resource "aws_subnet" "public_subnet_az" {
  provider                = aws.useast1
  vpc_id                  = aws_vpc.public.id
  cidr_block              = var.network_info.public_vpc_info.subnet_cidr_block
  availability_zone       = var.network_info.public_vpc_info.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = var.network_info.public_vpc_info.subnet_tags
  }
  depends_on = [ aws_vpc.public ]
}

# Create Internet Gateway and attach it to VPC
resource "aws_internet_gateway" "internet_gateway" {
  provider = aws.useast1
  vpc_id   = aws_vpc.public.id

  tags = {
    Name = "igw"
  }
  depends_on = [ aws_vpc.public, aws_subnet.public_subnet_az ]
}

# Create Public Route Table and add Public Route
resource "aws_route_table" "public_route_table" {
  provider = aws.useast1
  vpc_id   = aws_vpc.public.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "public_route"
  }
  depends_on = [ aws_vpc.public , aws_internet_gateway.internet_gateway ]
}

# Associate Public Subnet AZ to "Public Route Table"
resource "aws_route_table_association" "public_subnet_az_rt_association" {
  provider       = aws.useast1
  subnet_id      = aws_subnet.public_subnet_az.id
  route_table_id = aws_route_table.public_route_table.id
  depends_on = [ aws_vpc.public, aws_subnet.public_subnet_az, aws_route_table.public_route_table ]
}

# Create Public Subnet AZ1
resource "aws_subnet" "public_subnet_az1" {
  provider                = aws.useast2
  vpc_id                  = aws_vpc.private.id
  cidr_block              = var.network_info.private_vpc_info.subnet_cidr_block[0]
  availability_zone       = var.network_info.private_vpc_info.availability_zones[0]
  map_public_ip_on_launch = true

  tags = {
    Name = var.network_info.private_vpc_info.subnet_tags[0]
  }
  depends_on = [ aws_vpc.private ]
}

# Create Private Subnet AZ2
resource "aws_subnet" "private_subnet_az2" {
  provider                = aws.useast2
  vpc_id                  = aws_vpc.private.id
  cidr_block              = var.network_info.private_vpc_info.subnet_cidr_block[1]
  availability_zone       = var.network_info.private_vpc_info.availability_zones[1]
  map_public_ip_on_launch = false

  tags = {
    Name = var.network_info.private_vpc_info.subnet_tags[1]
  }
  depends_on = [ aws_vpc.private ]
}

# Create an Internet Gateway for the private VPC
resource "aws_internet_gateway" "igw" {
  provider = aws.useast2
  vpc_id   = aws_vpc.private.id
  tags = {
    Name = "igw-private"
  }
  depends_on = [ aws_vpc.private, aws_subnet.public_subnet_az1 ]
}

# Create public route table and route 

resource "aws_route_table" "public_route_table_nat" {
  provider = aws.useast2
  vpc_id   = aws_vpc.private.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-Nat-rt"
  }
  depends_on = [ aws_vpc.private , aws_subnet.public_subnet_az1 , aws_internet_gateway.igw ]
}

# Associate Public Subnet AZ1 to "Public Route Table"

resource "aws_route_table_association" "public_subnets_association_nat"{
     provider = aws.useast2
     subnet_id = aws_subnet.public_subnet_az1.id 
     route_table_id = aws_route_table.public_route_table_nat.id
     depends_on = [ aws_vpc.private, aws_subnet.public_subnet_az1 ]
}

# Create an Elastic IP in the second region
resource "aws_eip" "eip_for_nat_gateway_az" {
  provider = aws.useast2
  domain   = "vpc"

  tags = {
    Name = "eip-useast2"
  }
  depends_on = [ aws_vpc.private ]
}

# Create Nat Gateway in Public Subnet AZ1
resource "aws_nat_gateway" "nat_gateway_az" {
  provider       = aws.useast2
  allocation_id  = aws_eip.eip_for_nat_gateway_az.id
  subnet_id      = aws_subnet.public_subnet_az1.id

  tags = {
    Name = "nat_gateway"
  }

  # to ensure proper ordering, it is recommended to add an explicit dependency
  depends_on = [ aws_vpc.private, aws_internet_gateway.igw]
}

# Create Private Route Table AZ and add route through Nat Gateway AZ
resource "aws_route_table" "private_route_table_az" {
  provider = aws.useast2
  vpc_id   = aws_vpc.private.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_az.id
  }

  tags = {
    Name = "priavte_route_table"
  }
  depends_on = [ aws_vpc.private, aws_internet_gateway.igw ]
}

# Associate Private Subnet AZ2 with Private Route Table AZ
resource "aws_route_table_association" "private_subnet_az2_route_table_az2_association" {
  provider       = aws.useast2
  subnet_id      = aws_subnet.private_subnet_az2.id
  route_table_id = aws_route_table.private_route_table_az.id
  depends_on = [ aws_vpc.private , aws_subnet.private_subnet_az2 , aws_route_table.private_route_table_az ]
}
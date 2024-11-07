provider "aws" {
    region = "ap-south-1a"
  
}
resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"   
}
resource "aws_subnet" "name" {
    vpc_id = aws_vpc.name.id
    count = 4
    cidr_block = [10.0.0.0/16 , 8 , count.index]
    tags = {
      Name = "subnet[count.index]
    }
}

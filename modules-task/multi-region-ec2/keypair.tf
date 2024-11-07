resource "aws_key_pair" "my_key_pair_region_1" {
  provider = aws.us_east_1
  key_name   = "my_key_pair"
  public_key = file(var.key_pair_info.region_1)  
}

resource "aws_key_pair" "my_key_pair_region_2" {
  provider = aws.us_east_2
  key_name   = "my_key_pair"
  public_key = file(var.key_pair_info.region_2)  
}
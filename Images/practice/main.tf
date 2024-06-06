provider "aws" {
    region = "us-east-1"
  
}
resource "aws_instance" "name" {
    ami = ""
    key_name =  
    security_groups = [  ]
    subnet_id = 
    user_data =
    vpc_id =    
}
resource "null_resource" "name" {
    connection {
      type = "ssh"
      user = "ubuntu"
      key_name = "-.pem"
      host = "public_ip"
    }
    provisioner "file" {
        source = ""
        destination = ""
      
    }
    provisioner "remote-exec" {
        inline = [ "apt update" ,
         "apt install openjdk-17-jdk -y" ]
      
    }
  
}
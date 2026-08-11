provider "aws" {
  region = "ap-south-1"
  profile = "configs"
}



resource"aws_instance" "web_server" {
  ami           = var.instamid
  instance_type = var.intype
  vpc_security_group_ids = [var.sg]
 
  key_name = var.key
}

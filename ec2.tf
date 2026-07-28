provider "aws" {
  region = "us-east-1"
  access_key = "my acces-key"
  secret_key = "my-secret-key"
}

resource "aws_instance" "web_server" {
  ami           = ""
  instance_type = "t2.micro"
  vpc_security_group_ids =
  key_name =

  
}



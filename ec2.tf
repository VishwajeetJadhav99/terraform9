provider "aws" {
  region = "ap-south-1"
  access_key = "my acces-key"
  secret_key = "my-secret-key"
}

resource "aws_instance" "web_server" {
  ami           = "ami-0884624fc54d115f3"
  instance_type = "t3.micro"
  vpc_security_group_ids = ["sg-0fecd01f792e2c2e8"]
  key_name = "linux-newkey"
  tags = {
    purpose = "practice"
  }
  count = 2

  
}



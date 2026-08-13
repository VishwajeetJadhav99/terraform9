provider "aws" {
  region = "ap-south-1"
  profile = "configs"
}

resource "aws_instance" "web_server" {
  ami           = var.instamid
  instance_type = var.intype
  vpc_security_group_ids = [ var.sg , aws_security_group.sg_group.id ]
  key_name = var.key
 
 }

 resource "aws_security_group" "sg_group" {
  name = "sg.tf_group"
  depends_on = ["aws_instance.web_server"]
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
  

  ingress {
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
  
   

   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
  
   
}
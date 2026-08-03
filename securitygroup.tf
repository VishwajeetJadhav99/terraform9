provider "aws" {
  region = "ap-south-1"
  profile = "configs"
}

resource "aws_instance" "web_server" {
  ami           = var.instamid
  instance_type = var.intype
  vpc_security_group_ids = [ var.sg , aws_security_group.sg_group.id , data.aws_security_group.security_group.id  ]
  key_name = var.key
  tags = {
    purpose = "practice"
 }
  count = var.instno
  disable_api_termination = var.insdelprotection
  user_data = <<-EOF
              #!/bin/bash
              sudo yum install nginx -y
              sudo systemctl start nginx



    

              EOF

} 
resource "aws_security_group" "sg_group" {
  name = "sg.tf_group"
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

data "aws_security_group" "security_group" {

  name = "launch-wizard-6"

}

output "insta_ip" {
  value = aws_instance.web_server.public_ip

}

output "pubdns" {

  value = aws_instance.web_server.public_dns
}


  
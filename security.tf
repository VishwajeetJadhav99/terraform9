provider "aws" {
  region = "ap-south-1"
  access_key = "my acces-key"
  secret_key = "my-secret-key"
}

resource "aws_instance" "web_server" {
  ami           = "ami-0884624fc54d115f3"
  instance_type = "t3.micro"
  vpc_security_group_ids = ["sg-0fecd01f792e2c2e8" , aws_security_group.sg_group  ]
  key_name = "linux-newkey"
  tags = {
    purpose = "practice"
 }
  count = 2
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
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
  

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
  
   

   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
  
   
}





  
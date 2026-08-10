resource "aws_instance" "web_server" {
  ami           = var.instamid
  instance_type = var.intype
 
  key_name = var.key
  subnet_id = var.ws_subnet
  tags = {
    purpose = "practice"
 }
  
  disable_api_termination = var.insdelprotection
  user_data = <<-EOF
              #!/bin/bash
              sudo yum install nginx -y
              sudo systemctl start nginx



    

              EOF

} 
resource "aws_instance" "web_server" {
  ami           = var.instamid
  instance_type = var.intype
  vpc_security_group_ids = [ var.sg ]
  key_name = var.key
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
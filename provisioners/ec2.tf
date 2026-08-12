provider "aws" {
  region = "ap-south-1"
  profile = "configs"
}



resource "aws_instance" "web_server" {
  ami           = var.instamid
  instance_type = var.intype
  vpc_security_group_ids = [var.sg]
 
  key_name = var.key


provisioner "file" {
   source = "sample.txt"
   destination = "/home/ec2-user/aws"
}


provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
}

connection {
   type = "ssh"
   user = "ec2-user"
   private_key = file("${path.module}/tf.pem")
   host = self.public_ip

}

provisioner "remote-exec" {
    sudo systemctl start httpd
    sudo yum install httpd -y
    sudo yum update
    sudo yum upgrade
    sudo systemctl enable httpd

}







}


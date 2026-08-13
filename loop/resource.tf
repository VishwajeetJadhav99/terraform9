provider "aws" {
  region = "ap-south-1"
  profile = "configs"
}


resource"aws_instance" "web_server" {
  ami           = var.instamid
  instance_type = var.intype
  vpc_security_group_ids = [var.sg]
  key_name = var.key
  count = 2 #this is called identical loop because it is used make identical resources 
  
}



resource"aws_instance" "web_server2" {
  for_each = toset(var.imageid) #for inidentical loops

  ami           = each.value
  instance_type = var.intype
  vpc_security_group_ids = [var.sg]
  key_name = var.key
  
  
}


var "imageid" {
   default = ["ami-035827357e3c7e810", "ami-01a00762f46d584a1", "ami-017bc606d6a02cb3a" ]
}

output "ips" {
    value = [
        for amid in var.imageid:
          aws_instance.web_server2[amid].public_ip
    ]
}


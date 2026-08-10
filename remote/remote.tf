provider "aws" {
  region = "ap-south-1"
  profile = "configs"
}

#Partitionkey = LockID
terraform {
    backend "s3" {
        bucket = "vj99"
        key = "terraform.tfstate"
        dynamodb_table = "vj9"
        region = "ap-south-1"
        profile = "configs"
        shared_credentials_files = ["/root/.aws/credentials"]
    }
}




resource"aws_instance" "web_server" {
  ami           = var.instamid
  instance_type = var.intype
  vpc_security_group_ids = [var.sg]
 
  key_name = var.key
}
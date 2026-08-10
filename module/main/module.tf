module "ec2" {
   source = "./module/resource/ec2"
   instamid = ami-035827357e3c7e81
   intype = t3.micro
   sg = sg-0fecd01f792e2c2e8
   key = linux-newkey
   insdelprotection = false

   ws_subnet = module.vpc.subnet_id
}

module "vpc" {
    source = "./module/resource/vpc"
    this_cidr = "10.0.0.0/16"
    "this_subcidr = "10.0.1.0/24"

}
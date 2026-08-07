resource "aws_vpc" "webserver_vpc" {
    cidr_block = var.this_vpc_cidr
}


resource "aws_subnet" "webserver_subnet" {
    vpc_id = aws_vpc.webserver_vpc
}
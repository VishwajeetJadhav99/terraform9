resource "aws_vpc" "webserver_vpc" {
    cidr_block = var.this_cidr
}


resource "aws_subnet" "webserver_subnet" {
    vpc_id = aws_vpc.webserver_vpc.id
    cidr_block = var.this_subcidr
}
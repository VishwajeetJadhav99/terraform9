output "subnet_id" {
    value = aws_subnet.webserver_subnet.id
}

output "vpc_id" {

    value = aws_vpc.webserver_vpc.id
}
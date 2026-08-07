output "insta_ip" {
  value = aws_instance.web_server.public_ip

}

output "pubdns" {

  value = aws_instance.web_server.public_dns
}


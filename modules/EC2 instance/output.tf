output "public_ip_bastion" {
    value = aws_instance.bastion_host.public_ip_bastion
  
}
output "private_ip_webserver" {
    value = aws_instance.webserver.private_ip_webserver
}
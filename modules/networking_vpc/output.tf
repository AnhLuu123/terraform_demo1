output "vpc" {
value = module.vpc  
}
output "sg_public_id" {
    value = aws_security_group.ssh_anywhere.sg_public_id
  
}
output "sg_private_id" {
    value = aws_security_group.allow_ssh_private.sg_private_id
  
}
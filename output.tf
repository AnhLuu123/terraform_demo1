//VPC
output "vpc_id" {
    value = aws_vpc.myvpc.id
  
}
output "public-subnet-1" {
    value = [aws_subnet.public-subnet-1]
  
}
output "public-subnet-2" {
    value = [aws_subnet.public-subnet-2]
  
}
output "gateway_id" {
    value = aws_internet_gateway.ig_gw.id
  
}



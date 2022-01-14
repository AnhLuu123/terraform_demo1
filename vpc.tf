resource "aws_vpc" "myvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    "Name" = "myvpc"
  }
}
// create 4 subnet 
// create 2 public subnet
resource "aws_subnet" "public-subnet-1" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "${var.public-subnet-1-cidr}"
    availability_zone = "ap-southeast-1a"  
    map_public_ip_on_launch = true
    
    tags = {
      "Name" = "public-subnet-1"
    }


}
resource "aws_subnet" "public-subnet-2" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "${var.public-subnet-2-cidr}"
    availability_zone = "ap-southeast-1b"
    map_public_ip_on_launch = true
    tags = {
      "Name" = "public-subnet-2"
    }

  
}
// create 2 private subnet
resource "aws_subnet" "private-subnet-1" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "${var.private-subnet-1-cidr}"
    availability_zone = "ap-southeast-1a"
    map_public_ip_on_launch = false
    tags = {
      "Name" = "private-subnet-1"
    }
  
}
resource "aws_subnet" "private-subnet-2" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "${var.private-subnet-2-cidr}"
    availability_zone = "ap-southeast-1b"
    map_public_ip_on_launch = false
    tags = {
      "Name" = "private-subnet-2"
    }
  
}
// tạo internet gateway
resource "aws_internet_gateway" "ig_gw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    "Name" = "ig_gw"
  }
  
}
// create route table for VPC
resource "aws_route_table" "route_vpc_public" {
  vpc_id = aws_vpc.myvpc.id
  route  {
    cidr_block = "0.0.0.0/0" // internet
    gateway_id = aws_internet_gateway.ig_gw.id
    
  }
  tags = {
    "Name" = "route_vpc"
  }
  
}
// associate route for public subnet
resource "aws_route_table_association" "route-public-subnet-1" {
  subnet_id = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.route_vpc_public.id

}
resource "aws_route_table_association" "route-public-subnet-2" {
  subnet_id = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.route_vpc_public.id

}

// create 1 secuirty group allow connections from myIP
resource "aws_security_group" "SG_bastion" {
  name = "SG_bastion"
  description = "allow ssh inbound VPC"
  vpc_id = aws_vpc.myvpc.id
  
  ingress  {
    description = "ssh from myIP "
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["14.231.157.198/32"] 
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "SG_bastion"
  }
  
}
// SG to only allow connection from SG_bastion
resource "aws_security_group" "SG-web-private" {
  name = "SG-web-private"
  description = "Allow ssh inbound traffic"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "SG-web-private"
  }
}










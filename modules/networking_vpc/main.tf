data "aws_availability_zones" "availables" {
  
}
module "vpc" {
    source = ""  
  
}
// create aws VPC
resource "aws_vpc" "vpc" {
    cidr_block = "${var.vpc-cidr}"
    instance_tenancy = "default"
    enable_dns_hostnames = true
    enable_nat_gateway = true

tags = {
  "name" = "lab_vpc"
}
  
}
//create subnet in VPC : this is will create 1 VPC with 4 subnet
// create 2 public subnets in VPC  

resource "aws_subnet" "public-subnet-1" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "${var.public-subnet-1-cidr}"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true

    tags {
      Name = "public-subnet 1"
    }
}

resource "aws_subnet" "public-subnet-2" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "${var.public-subnet-2-cidr}"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    tags  {
      Name = "public subnet 2"
    }
}
// create 2 private subnet 
resource "aws_vpc" "private-subnet-1" {
    vpc_id = aws_vpc.vpc.id 
    cidr_block = "${var.private-subnet-1}"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true
    tags  {
      Name = "private subnet 1"
    
    }
  
}
resource "aws_subnet" "private-subnet-2" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "${var.private-subnet-2-cidr}"
    avaavailability_zone = "us-east-1b"
    map_public_ip_on_launch = true
    tags {
        Name = "private subnet 2"
    }   
}
// define the internet gateway
resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.vpc.id
    tags {
        Name = "vpc_gw"
    }
  
}
// define routing table for VPC
resource "aws_route_table" "routertb" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"

    }
    // all IPs
    gateway_id = aws_internet_gateway.gw.id
}
tags {
    Name = "routertable"
}
// create SG for VPC to allow ssh from anywhere
resource "aws_security_group" "ssh_anywhere" {
name = "security group allow ssh"
description = "Allow ssh inbound traffic from anywhere"
vpc_id = aws_vpc.vpc.id

ingress {
    description = "ssh from the internet"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

}
egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}
tags  {
    Name = "sg ssh from anywhere"
}
}
// create SG to ssh only bastion host from vpc private subnet
resource "aws_security_group" "allow_ssh_private" {
    name = "ssh from private"
    description = "Allow ssh inbound trafic"
    vpc_id = aws_vpc.vpc.id

    ingress{
        description = "ssh only from internal VPC cliens"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["10.0.0.0/16"]
    }  
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "ssh only from bastion host to private"
    }
}




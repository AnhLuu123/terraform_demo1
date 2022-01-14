variable "aws_access-key" {
type = string
default = "AKIAVXAZV6CB6YHFTWWW"
}
variable "aws_secret-key" {
    type = string
    default = "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"
}
variable "aws_region" {
    default = "us-west-1"
}
variable "vpc-cidr"{
default = "10.0.0.0/16"
description = "aws region"
type = string
}
variable "public-subnet-1-cidr" {
    type = string
    default = "10.0.0.0/24"
    description = "public subnet 1 CIDR Block"

}
variable "public-subnet-2-cidr" {
    type = string
    default = "10.0.1.0/24"
    description = "public subnet 2 CIDR Block"
  
}
variable "private-subnet-1-cidr" {
    type = string
    default = "10.0.1.0/24"
    description = "private subnet 1 CIDR Block"
}
variable "private-subnet-2-cidr" {
    type = string
    default = "10.0.1.0/24"
    description = "private subnet 2 CIDR Block"
}
variable "vpc_id" {
    type = string
    description = "VPC ID where bastion hosts and security group will be created"
}
   
  

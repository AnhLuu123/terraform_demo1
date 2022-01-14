variable "vpc" {
    type =  anywhere
  
}
variable "key_name" {
 type =any  
}
variable "sg_pub_id" {
 type = any
  
}
variable "sg_private_id" {
    type = any
  
}
variable "environment" {
  description = "Environment "
  default = "dev"
}
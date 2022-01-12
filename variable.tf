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
    default = "10.0.2.0/24"
    description = "private subnet 1 CIDR Block"
  
}
variable "private-subnet-2-cidr" {
    type = string
    default = "10.0.3.0/24"
    description = "private subnet 2 CIDR Block"
  
}
variable "public-key"{
    default = "webserver.pub"
}


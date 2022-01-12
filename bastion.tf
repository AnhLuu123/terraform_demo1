data "aws_ami" "amazon-linux-2" {
    most_recent = true
    owners = ["amazon"]

    filter {
      name = "name"
      values = ["amzn2-ami-hvm*"]
    }
      
}
// bastion in public subnet
resource "aws_instance" "bastion" {
    ami = data.aws_ami.amazon-linux-2.id
    associate_public_ip_address = true
    instance_type = "t2.micro"
    key_name = "mykeyauth1"
    subnet_id = aws_subnet.public-subnet-1.id
    vpc_security_group_ids = [aws_security_group.SG_bastion.id]
    tags = {
      "Name" = "bastion"
    }
  
}
resource "aws_key_pair" "mykeyauth1"{
  key_name = "mykeyauth1"
  public_key = file(var.public-key1)
}

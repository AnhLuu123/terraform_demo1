// create key-pair
resource "aws_key_pair" "mykey"{
  key_name = "mykeyauth"
  public_key = file(var.public-key)
}

// web instance in public

resource "aws_instance" "webserver" {
    ami = data.aws_ami.amazon-linux-2.id
    associate_public_ip_address = true
    instance_type = "t2.micro"
    key_name = "webserver"
    subnet_id = aws_subnet.public-subnet-2.id
    vpc_security_group_ids = [aws_security_group.SG-web-private.id]
    user_data     = <<-EOF
                  #!/bin/bash 
                  sudo su
                  yum -y update
                  amazon-linux-extras install nginx1.12-y
                  echo "<p> My Instance! </p>" >> /var/www/html/index.html
                  systemctl start nginx.service
                  systemctl enable nginx.service
                  EOF 
            
    tags = {
      "Name" = "webserver"
    }
       
}
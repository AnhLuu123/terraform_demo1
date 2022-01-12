//define target group
resource "aws_lb_target_group" "lb-sg" {
  health_check{
    interval = 10
    path = "/" //check from index file
    protocol = "http"
    timeout = 5
    healthy_threshold = 5
    unhealth_threshold = 2
  }

  name = "lb-sg"
  port = 80
  protocol = "http"
  target_type = "instance"
  vpc_id = aws_vpc.myvpc.id 
  
}
resource "aws_lb_target_group_attachment" "my-lb" {
  target_group_arn = "aws_lb_target_group.lb-sg.arn"
  target_id = aws_instance.webserver.id
  port = 80
  
}
// define lb
resource "aws_lb" "app-lb" {
  name = "app-lb"
  internal = false
  security_groups = [aws_security_group.sg_lb.id]
  subnets = ["aws_subnet.subnet-public-1","aws_subnet.subnet-public-2"]
  tags = {
    "Name" = "app-lb"

  }
ip_address_type = "ipv4"
loadload_balancer_type = "application"

}
resource "aws_security_group" "sg_lb" {
    vpc_id = aws_vpc.myvpc.id
    name = "sg_lb"
    description = "security for lb"
    
}
resource "aws_security_group_rule" "inbound_ssh" {
  from_port = 22
  protocol = "tcp"
  security_group_id = "aws_security_group.sg-lb.id"
  to_port = 22
  type =  "ingress"
  cidr_blocks = ["0.0.0.0/0"]
 
}
resource "aws_security_group_rule" "inbound_http" {
  from_port = 80
  protocol = "tcp"
  security_group_id = "aws_security_group.sg-lb.id"
  to_port = 80
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
  
}
resource "security_group_group_rule" "outbound_all" {
  from_port = 0
  protocol = "-1"
  security_group_id = "aws_security_group.sg-lb.id"
  to_port = 0
  type = "egress"
  cidr_block = ["0.0.0.0/0"]
  
}
    tags = {
      "Name" = "sg_lb"
    }
 
resource "aws_lb_listener" "lb-listner" {
  load_balancer_arn = aws_lb.app-lb.arn
  port = 80
  protocol = "http"
  
  default_action {
    target_group_arn = aws_lb_target_group.lb-sg.id
    type = "forward"
  }
}



































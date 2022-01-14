// this data source fetch all aws availablity zones and stores them to available 
data "aws_availability_zones" "available" {
  
}
data "aws_ami" "linux" {
    most_recent = true
    owners = ["amazon"]
    filter {
      name = "name"
      value = ["amazone-ami"]
    } 
}
// create bastion host in a public subnet
resource "aws_instance" "bastion_host" {
    ami = data.aws_ami.linux.id
    associate_public_ip_address = true
    instance_type = "t2.micro"
    key_name = var.key_name
    subnet_id = var.vpc.public-subnet-1
     vpc_security_group_ids = [var.sg_pub_id]

     tags = {
       "name" = ""
     }  

// copies the ssh key file to homw dir
provider "file" {
    source ="./${var.key_name}.pem"
    destination = "/home/ec2-user/${var.key_name}.pem"

connection{
    type = "ssh"
    user = "ec2-user"
    private_key = file("${var.key_name}.pem")
    host = self.map_public
}
}
// chmod key 400 on ec2 instance ( read)
provisioner "remote-exec" {
    inline = [
      "chmod 400 ~/${var.key_name}.pem"
    ]
connection {
  type = "ssh"
  users = "ec2-user"
  private_key = file("${var.key_name}.pem")
  host = self.public_ip
}
}
}
// create ec2 instance webserver nginx in a private subnet
resresource "aws_instance" "webserver" {
    ami = data.aws_ami.linux.id
    associate_public_ip_address  = false
    instance_type = "t2.micro"
    key_name = var.key_name
    subnet_id = var.vpc.private-subnet-1.id
    vpc_security_group_ids = [var.sg.private-id]
    port = 80

tags ={
    "Name" = "webserver_nginx"
}
provisioner "file" {
  source = "installnginx.sh"
  destination = " /tmp/installnginx.sh"
  
}
provisioner "remote-exec" {
  inline =[

    "chmod +x /tmp/installnginx.sh" ,
    "sudo /tmp/installnginx.sh",
  ]

}
// connect ec2 web only ssh from bastion host
connection {
      type        = "ssh"
      user        = "bastion_host"
      private_key = file("${var.key_name}.pem")
      host        = self.private_ip_webserver
    }
}  
// create  rds mysql private subnet
resource "aws_db_instance" "rds_mysql" {
  identifier = "mysqldatabase"
  storage_type = "gp2" // general purpose ssd
  allocated_storage = 20
  engine = "mysql"
  engine_version = "8.0"
  instance_class = "db.t2.micro"
  port = "3306" // the port on, which database accepts connections
  db_subnet_group_name = "default"
  name = "mydb"
  username = var.username
  password = var.password
  parameter_group_name = "default"
  availability_zone = "us-east-1b"
  publicly_accessible = false 
  deletion_protection = true 
  skip_final_snapshot = true 
  

  tags {
    Name = "my mysql demo"
  }  
  
}
// chưa hoàn thành 
// build auto scaling group 
resource "aws_autoscaling_group" "AutoScallingGroup" {
    name = "myECSAutoScallingGroup"
    launch_configuration = aws_launch_configuration.ECSConfigruation.name
    vpc_zone_identifier = [var.private_subnet_1, var.private_subnet_2]
    min_size = 1
    max_size = var.autoscallingMaxSize
    desired_capacity = var.desiredCapacity
    health_check_type = "EC2"

}

resource "aws_launch_configuration" "ECSConfigruation" {
  image_id = var.ec2AMI
  instance_type = var.instanceType
  security_groups = [aws_security_group.Autoscalling.id]
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.ECS-InstanceProfile.arn
  key_name = var.keyName
  user_data = data.template_cloudinit_config.myECSUserData.rendered
}

resource "aws_appautoscaling_target" "AutoScallingTarget" {
  depends_on = [aws_ecs_service.eCommerceService]
  min_capacity       = var.desiredCapacity
  max_capacity       = var.autoscallingMaxSize
  resource_id        = "service/ecommerceCluster/ecommerceService"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  role_arn = aws_iam_role.Terraform-ECS-Autoscalling-Role.arn
}

resource "aws_appautoscaling_policy" "ECS" {
  name               = "AStepPolicy"
  policy_type        = "StepScaling"
  resource_id         = aws_appautoscaling_target.AutoScallingTarget.id
  scalable_dimension = aws_appautoscaling_target.AutoScallingTarget.scalable_dimension
  service_namespace  = aws_appautoscaling_target.AutoScallingTarget.service_namespace

  step_scaling_policy_configuration {
    adjustment_type = "PercentChangeInCapacity"
    cooldown = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = 200
    }

  }
  // chưa hoàn thành 
// build ALB ( load balacer)

resource "aws_lb" "ALB" {
  name               = "myALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ALB.id]
  subnets            = [var.private_subnet_1, var.private_subnet_2]
  idle_timeout       = 30

  enable_deletion_protection = false

}

  tags = {
    Environment = var.environment
  }

resource "aws_lb_listener" "ALBListener" {
  load_balancer_arn = aws_lb.ALB.arn
  port = "443"
  protocol = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default.arn
  }
}

resource "aws_lb_listener_rule" "ALBListenerRule" {

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Blue.arn
  }

  condition {
    path_pattern {
      values = ["/polls*","/admin*"]
    }
  }

  listener_arn = aws_lb_listener.ALBListener.arn
  priority     = 2

}


}
//define aws_launch_configuration
resource "aws_launch_configuration" "ec2_config" {
  name = "ec2_config"
  image_id = aws_instance.webserver.id
  instance_type = "t2.micro"

}
// define template
resource "aws_launch_template" "template-webserver" {
  name_prefix = "template-webserver"
  image_id = data.aws_ami.template-webserver.id
  instance_type = "t2.micro" 
}
// define autoScaling group
resource "aws_autoscaling_group" "autoscaling" {
  name = "autoscaling"
  vpc_zone_identifier = [aws_subnet.public-subnet-1.id,aws_subnet.public-subnet-2.id]
  launch_configuration = aws_launch_configuration.ec2_config.name
  min_size = 1
  max_size = 3
  health_check_grace_period = 100
  health_check_type = "ec2"
  force_delete = true
  tag{
    key = "Name"
    value = "autoscaling"
    propagate_at_launch = true
  }
  
}









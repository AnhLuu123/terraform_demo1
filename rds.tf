resource "aws_db_instance" "db" {
    identifier = "mysqldatabase"
    storage_type = "gp2" //default
    allocated_storage = 20
    engine = "mysql"
    engine_version = "5.7"
    instance_class = "db.t2.micro"
    port = "3360"
    name = "rds_mysql"
    username = "anhluu"
    password = "anhluu99"
    parameter_group_name = "default.mysql5.7"


    publicly_accessible = false
    skip_final_snapshot = true

    tags = {
        name = "rds_mysql"
    }
     
}

resource "aws_db_subnet_group" "sg-db"{
    name = "sg-db"
    subnet_ids = [aws_subnet.private-subnet-1.id,aws_subnet.private-subnet-2.id]

    tags = {
        Name = "sg-db"
    }
}
resource "aws_security_group" "rds_sg" {
    name = "rds_sg"
    vpc_id = aws_vpc.myvpc.id 
  
}
resource "aws_security_group_rule" "sg_inbound" {
    from_port = 3306
    protocol = "TCP"
    security_group_id = aws_security_group.rds_sg.id
    to_port = 3306
    type = "ingress"
    cidr_blocks = ["0.0.0.0/0"]

  
}

resource "aws_security_group_rule" "sg_outbound" {
    from_port = 0
    protocol = "-1"
    security_group_id = aws_security_group.rds_sg.id
    to_port = 0
    type = "egress"
    cidr_blocks = ["0.0.0.0/0"]
  
}







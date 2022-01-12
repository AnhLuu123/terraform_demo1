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
    db_subnet_group_name = "aws_db_subnet_group.sg-db"
    publicly_accessible = false
    skip_final_snapshot = true

    tags = {
        name = "rds_mysql"
    }
     
}

resource "aws_db_subnet_group" "sg-db"{
    name = "sg-db"
    subnet_ids = [aws_subnet.private-subnet-1.id]

    tags = {
        Name = "sg-db"
    }
}




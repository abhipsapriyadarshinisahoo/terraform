


# resource "aws_db_subnet_group" "db_subnet_group" {
#   name       = "db-subnet-group"
#   subnet_ids = [var.subnet_1_id, var.subnet_2_id]
  

#   tags = {
#     Name = "My DB Subnet Group"
#   }
# }

# resource "aws_db_instance" "mysql" {
#   allocated_storage    = 20
#   engine               = "mysql"
#   engine_version       = "8.0"
#   instance_class       = var.instance_class
#   db_name              = var.db_name
#   username             = var.db_user
#   password             = var.db_password
#   db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
#   skip_final_snapshot  = true
# }






variable "subnet_1_id" {}
variable "subnet_2_id" {}
variable "instance_class" {}
variable "db_name" {}
variable "db_user" {}
variable "db_password" {}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = [var.subnet_1_id, var.subnet_2_id]

  tags = {
    Name = "My DB Subnet Group"
  }
}

resource "aws_db_instance" "mysql" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = var.instance_class
  db_name              = var.db_name
  username             = var.db_user
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  skip_final_snapshot  = true
}

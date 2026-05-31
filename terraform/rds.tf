resource "aws_db_subnet_group" "bedrock" {
  name       = "project-bedrock-db-subnets"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "project-bedrock-db-subnets"
  }
}

resource "random_password" "mysql" {
  length  = 24
  special = false
}

resource "random_password" "postgres" {
  length  = 24
  special = false
}

resource "aws_db_instance" "mysql" {
  identifier = "project-bedrock-mysql"

  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp3"
  db_name           = "catalog"
  username          = "catalogadmin"
  password          = random_password.mysql.result
  port              = 3306

  db_subnet_group_name   = aws_db_subnet_group.bedrock.name
  vpc_security_group_ids = [aws_security_group.rds_mysql.id]

  multi_az            = false
  publicly_accessible = false
  skip_final_snapshot = true

  tags = {
    Name = "project-bedrock-mysql"
  }
}

resource "aws_db_instance" "postgres" {
  identifier = "project-bedrock-postgres"

  engine         = "postgres"
  engine_version = "16"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp3"
  db_name           = "orders"
  username          = "ordersadmin"
  password          = random_password.postgres.result
  port              = 5432

  db_subnet_group_name   = aws_db_subnet_group.bedrock.name
  vpc_security_group_ids = [aws_security_group.rds_postgres.id]

  multi_az            = false
  publicly_accessible = false
  skip_final_snapshot = true

  tags = {
    Name = "project-bedrock-postgres"
  }
}

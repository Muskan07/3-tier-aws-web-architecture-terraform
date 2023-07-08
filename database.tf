module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "example-rds-db"

  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t2.small"
  allocated_storage = 5

  db_name                   = var.database_name
  username                  = var.username
  port                      = "3306"
  password                  = var.password
  create_db_option_group    = false
  create_db_parameter_group = false
  multi_az                  = true

  vpc_security_group_ids = [aws_security_group.example-db-sg.id]

  tags = local.tags

  create_db_subnet_group = true
  subnet_ids             = module.vpc.database_subnets
  family                 = "mysql8.0"
  major_engine_version   = "8.0"
  deletion_protection    = false
  skip_final_snapshot    = true
}
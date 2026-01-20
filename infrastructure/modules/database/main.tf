locals {
  name_prefix = "${var.project_name}-${var.environment}"
  port        = var.db_engine == "mysql" ? 3306 : 5432
}

resource "aws_db_subnet_group" "this" {
  name       = "${local.name_prefix}-db-subnets"
  subnet_ids = var.db_subnet_ids
}

# Least-privilege inbound: ECS tasks -> DB port
resource "aws_security_group_rule" "db_ingress_from_ecs" {
  type                     = "ingress"
  security_group_id        = var.db_sg_id
  from_port                = local.port
  to_port                  = local.port
  protocol                 = "tcp"
  source_security_group_id = var.app_sg_id
}

resource "aws_db_instance" "this" {
  identifier        = "${local.name_prefix}-rds"
  engine            = var.db_engine
  engine_version    = var.db_engine_version
  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_gb
  db_name           = var.db_name

  multi_az            = true
  publicly_accessible = false
  storage_encrypted   = true

  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "sun:04:00-sun:05:00"

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.db_sg_id]

  username                    = "appadmin"
  manage_master_user_password = true

  deletion_protection = false
  skip_final_snapshot = true
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.private_subnets
}

resource "aws_db_instance" "this" {
  identifier = var.name
  engine = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_type
  username = var.db_username
  password = var.db_password
  allocated_storage = var.storage_gb
  multi_az = true
  skip_final_snapshot = false
  backup_retention_period = var.backup_retention
  db_subnet_group_name = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.db_sg_id]
  publicly_accessible = false
  tags = var.tags
}


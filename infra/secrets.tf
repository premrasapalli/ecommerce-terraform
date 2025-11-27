resource "aws_secretsmanager_secret" "db" {
  name        = "${var.project_name}-db-secret"
  description = "RDS master credentials for ${var.project_name}"
  tags        = var.tags
}

# Create an initial version with JSON containing username/password (sensitive)
resource "aws_secretsmanager_secret_version" "db_version" {
  secret_id     = aws_secretsmanager_secret.db.id
  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
    host     = module.rds.db_endpoint   # optional - can update with endpoint after rds created via apply
    port     = 5432
    dbname   = var.project_name
  })
}


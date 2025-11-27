# ===== PRODUCTION ENVIRONMENT =====

project_name     = "ecommerce"
aws_region       = "us-east-1"

image_tag        = "prod"

# Networking
vpc_cidr         = "10.0.0.0/16"
azs              = ["us-east-1a", "us-east-1b"]

# ECS
task_cpu         = 512
task_memory      = 1024
desired_count    = 2

# DB
db_engine_version = "15.3"
db_instance_type  = "db.t3.medium"
db_storage_gb     = 50
backup_retention  = 7

# No plain password
db_username       = "ecom_admin"

# Secrets Manager reference
db_secret_arn     = "arn:aws:secretsmanager:us-east-1:123456789012:secret:ecom-prod-db"

# ALB/HTTPS
enable_https      = true
certificate_arn   = "arn:aws:acm:us-east-1:123456789012:certificate/your-domain-cert"

tags = {
  environment = "production"
  managed_by  = "terraform"
}


# ===== STAGING ENVIRONMENT =====

project_name     = "ecommerce-staging"
aws_region       = "us-east-1"

image_tag        = "staging"

# Networking
vpc_cidr         = "10.10.0.0/16"
azs              = ["us-east-1a", "us-east-1b"]

# ECS
task_cpu         = 256
task_memory      = 512
desired_count    = 1

# DB
db_engine_version = "15.3"
db_instance_type  = "db.t3.micro"
db_storage_gb     = 20
backup_retention  = 1

# DO NOT put password here
db_username       = "staging_admin"

# Secrets Manager reference
db_secret_arn     = "arn:aws:secretsmanager:us-east-1:123456789012:secret:ecom-staging-db"

# ALB/HTTPS
enable_https      = false
certificate_arn   = ""

tags = {
  environment = "staging"
  managed_by  = "terraform"
}


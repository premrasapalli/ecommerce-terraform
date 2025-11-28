module "vpc" {
  source = "./modules/vpc"

  # VPC configuration
  cidr = "10.0.0.0/16"
  azs  = ["us-east-1a", "us-east-1b"]
}

module "rds" {
  source = "./modules/rds"

  # Database configuration
  db_username     = var.db_username
  db_password     = data.aws_secretsmanager_secret_version.db_secret.secret_string
  instance_type   = var.db_instance_type
  private_subnets = module.vpc.private_subnets
}

module "ecr" {
  source = "./modules/ecr"
}

module "alb" {
  source = "./modules/alb"

  # ALB configuration
  enable_https    = var.enable_https
  certificate_arn = var.certificate_arn
  domain_name     = var.domain_name
  public_subnets  = module.vpc.public_subnets
  project_name    = var.project_name
  tags            = var.tags
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  container_port  = 80
}

module "ecs" {
  source = "./modules/ecs"

  # Naming
  cluster_name = var.project_name
  name         = var.project_name

  # Image
  repo_url  = module.ecr.repository_url
  image_tag = var.image_tag

  # Task settings
  task_cpu      = var.task_cpu
  task_memory   = var.task_memory
  desired_count = var.desired_count

  # Networking
  subnet_ids         = module.vpc.private_subnets
  security_group_ids = [module.vpc.default_sg]

  # Load balancer connection
  alb_target_group_arn = module.alb.target_group_arn
  container_port       = 80
}


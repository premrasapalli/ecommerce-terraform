module "vpc" {
  source = "./modules/vpc"
  name   = "ecommerce"
  cidr   = "10.0.0.0/16"
  azs    = ["us-east-1a","us-east-1b"]
}

module "rds" {
  source        = "./modules/rds"
  name          = "ecom-db"
  vpc_id        = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  db_username   = var.db_username
  db_password   = data.aws_secretsmanager_secret_version.db_secret.secret_string
  instance_type = var.db_instance_type
}

module "ecr" {
  source = "./modules/ecr"
  name   = "ecommerce"
}

module "ecs" {
  source           = "./modules/ecs"
  name             = "ecommerce"
  vpc_id           = module.vpc.vpc_id
  private_subnets  = module.vpc.private_subnets
  public_subnets   = module.vpc.public_subnets
  alb_sg_id        = module.alb.alb_sg_id
  repo_url         = module.ecr.repository_url
  task_cpu         = var.task_cpu
  task_memory      = var.task_memory
  desired_count    = var.desired_count
}

module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  domain_name = var.domain_name
  certificate_arn = var.certificate_arn
  target_group_arn = module.ecs.target_group_arn
}


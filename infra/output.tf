##############################
# High-level useful outputs #
##############################

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnets
}

#####################
# ALB / App Outputs #
#####################

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "app_url" {
  description = "URL where your app is accessible"
  value       = "http://${module.alb.alb_dns_name}"
}

#####################
# ECS / ECR Outputs #
#####################

output "ecs_cluster_name" {
  description = "ECS Cluster name"
  value       = module.ecs.cluster_name
}

output "ecs_service_name" {
  description = "ECS Service name"
  value       = module.ecs.service_name
}

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = module.ecr.repository_url
}

##################
# RDS Outputs #
##################

output "rds_endpoint" {
  description = "RDS database endpoint"
  value       = module.rds.db_endpoint
}

output "database_url" {
  description = "Full database URL connection string"
  sensitive   = true
  value       = "postgres://${var.db_username}:${var.db_password}@${module.rds.db_endpoint}:5432/${var.project_name}"
}


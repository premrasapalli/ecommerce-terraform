###############
# Global Vars #
###############

variable "project_name" {
  description = "Name of the application"
  type        = string
  default     = "ecommerce"
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

##################
# Networking Vars #
##################

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "List of Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

######################
# ECS / App Settings #
######################

variable "task_cpu" {
  description = "CPU for ECS task"
  type        = number
  default     = 512
}

variable "task_memory" {
  description = "Memory for ECS task"
  type        = number
  default     = 1024
}

variable "desired_count" {
  description = "Desired number of ECS service tasks"
  type        = number
  default     = 2
}

variable "image_tag" {
  description = "Container image tag to deploy"
  type        = string
  default     = "latest"
}

###################
# Database Config #
###################

variable "db_username" {
  description = "Master username for RDS"
  type        = string
  default     = "ecom_admin"
}

variable "db_password" {
  description = "Password for RDS master user"
  type        = string
  sensitive   = true
}

variable "db_engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "15.3"
}

variable "db_instance_type" {
  description = "Instance class for RDS"
  type        = string
  default     = "db.t3.medium"
}

variable "db_storage_gb" {
  description = "Allocated storage for RDS"
  type        = number
  default     = 50
}

variable "backup_retention" {
  description = "Number of days to retain RDS backups"
  type        = number
  default     = 7
}

#########################
# Load Balancer & HTTPS #
#########################

variable "enable_https" {
  description = "Enable HTTPS listener on ALB"
  type        = bool
  default     = false
}

variable "certificate_arn" {
  description = "ACM certificate ARN"
  type        = string
  default     = ""
}

variable "domain_name" {
  description = "Custom domain (optional)"
  type        = string
  default     = ""
}

###################
# Tags / Metadata #
###################

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default = {
    project   = "ecommerce"
    terraform = "true"
  }
}


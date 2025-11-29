#######################
# Global / AWS Config #
#######################

variable "project_name" {
  description = "Name of the application"
  type        = string
  default     = "ecommerce"
}

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment (dev/staging/prod)"
  type        = string
  default     = "prod"
}


#################
# Networking    #
#################

variable "vpc_cidr" {
  description = "CIDR range for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}


############################
# ECS / App Configuration  #
############################

variable "task_cpu" {
  description = "ECS task CPU"
  type        = number
  default     = 512
}

variable "task_memory" {
  description = "ECS task memory"
  type        = number
  default     = 1024
}

variable "desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 2
}

variable "image_tag" {
  description = "Tag for the Docker image"
  type        = string
  default     = "latest"
}



#################
# Database Vars #
#################

variable "db_username" {
  description = "Master username for RDS"
  type        = string
  default     = "ecom_admin"
}

variable "db_password" {
  description = "Master DB password (if not using Secrets Manager)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "db_secret_arn" {
  description = "Secrets Manager ARN for DB login JSON"
  type        = string
  default     = ""
}

variable "db_engine_version" {
  description = "PostgreSQL version"
  type        = string
  default     = "15.3"
}

variable "db_instance_type" {
  description = "Instance class for RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "db_storage_gb" {
  description = "DB storage size"
  type        = number
  default     = 50
}

variable "backup_retention" {
  description = "Backup retention days"
  type        = number
  default     = 7
}


##############################
# HTTPS / ACM / Route53 Vars #
##############################

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
  description = "Domain name (optional)"
  type        = string
  default     = ""
}

variable "create_route53_records" {
  description = "Create DNS A/AAAA records for ALB/CloudFront"
  type        = bool
  default     = false
}


##############
# S3 / CDN   #
##############

variable "enable_cdn" {
  description = "Enable S3 + CloudFront deployment"
  type        = bool
  default     = false
}


###########
# Tags    #
###########

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default = {
    project   = "ecommerce"
    terraform = "true"
  }
}
variable "domain_alternatives" {
  type        = list(string)
  default     = []
  description = "Optional additional domain names for ACM"
}


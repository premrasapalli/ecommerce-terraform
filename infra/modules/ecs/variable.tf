#########################
# ECS Module Variables  #
#########################

variable "name" {
  description = "Name of the ECS cluster and application"
  type        = string
}

variable "task_cpu" {
  description = "CPU units for ECS task"
  type        = number
}

variable "task_memory" {
  description = "Memory for ECS task"
  type        = number
}

variable "desired_count" {
  description = "Desired number of containers"
  type        = number
}

variable "repo_url" {
  description = "Container repository URL (ECR repo)"
  type        = string
}

variable "image_tag" {
  description = "Image tag to deploy"
  type        = string
}

variable "subnet_ids" {
  description = "List of private subnets for ECS tasks"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security groups for ECS service"
  type        = list(string)
}

variable "alb_target_group_arn" {
  description = "ALB target group ARN for ECS service"
  type        = string
}


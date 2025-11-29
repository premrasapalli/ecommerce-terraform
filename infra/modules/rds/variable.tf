variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

variable "instance_type" {
  type = string
}


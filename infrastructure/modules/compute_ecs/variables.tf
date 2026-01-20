variable "project_name" { type = string }
variable "environment" { type = string }

variable "vpc_id" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "private_subnet_ids" { type = list(string) }

variable "alb_sg_id" { type = string }
variable "ecs_sg_id" { type = string }

variable "app_port" { type = number }
variable "health_path" { type = string }
variable "app_image" { type = string }

variable "ecs_cpu" { type = number }
variable "ecs_memory" { type = number }
variable "desired_count" { type = number }
variable "max_count" { type = number }

variable "enable_https" { type = bool }
variable "acm_cert_arn" { type = string }

variable "db_endpoint" { type = string }
variable "db_port" { type = number }
variable "db_secret_arn" { type = string }

variable "enable_vpc_endpoints" { type = bool }

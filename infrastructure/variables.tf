variable "project_name" {
  type    = string
  default = "bluebird"
}
variable "environment" {
  type    = string
  default = "dev"
}
variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.20.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.20.0.0/24", "10.20.1.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.20.10.0/24", "10.20.11.0/24"]
}

variable "db_subnet_cidrs" {
  type    = list(string)
  default = ["10.20.20.0/24", "10.20.21.0/24"]
}

# App / ECS
variable "app_port" {
  type    = number
  default = 3000
}
variable "health_path" {
  type    = string
  default = "/health"
}
variable "app_image" {
  type    = string
  default = "nginxdemos/hello:latest"
}

variable "ecs_cpu" {
  type    = number
  default = 256
}
variable "ecs_memory" {
  type    = number
  default = 512
}
variable "desired_count" {
  type    = number
  default = 2
}
variable "max_count" {
  type    = number
  default = 4
}

# Optional TLS
variable "enable_https" {
  type    = bool
  default = false
}
variable "acm_cert_arn" {
  type    = string
  default = ""
}

# Database
variable "db_engine" {
  type    = string
  default = "postgres"
}
variable "db_engine_version" {
  type    = string
  default = "15.5"
}
variable "db_instance_class" {
  type    = string
  default = "db.t4g.micro"
}
variable "db_allocated_gb" {
  type    = number
  default = 20
}
variable "db_name" {
  type    = string
  default = "bluebirdapp"
}

# Monitoring
variable "alarm_email" {
  type    = string
  default = ""
}

# Cost optimization
variable "enable_vpc_endpoints" {
  type    = bool
  default = true
}

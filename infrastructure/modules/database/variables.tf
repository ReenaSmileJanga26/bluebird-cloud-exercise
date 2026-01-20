variable "project_name" { type = string }
variable "environment" { type = string }

variable "db_engine" { type = string }
variable "db_engine_version" { type = string }
variable "db_instance_class" { type = string }
variable "db_allocated_gb" { type = number }
variable "db_name" { type = string }

variable "db_subnet_ids" { type = list(string) }
variable "db_sg_id" { type = string }
variable "app_sg_id" { type = string }
variable "project_name" { type = string }
variable "environment" { type = string }

variable "alb_arn_suffix" { type = string }
variable "tg_arn_suffix" { type = string }
variable "rds_instance_id" { type = string }

variable "alarm_email" { type = string }
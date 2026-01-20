output "db_endpoint" { value = aws_db_instance.this.address }
output "db_port" { value = aws_db_instance.this.port }
output "rds_instance_id" { value = aws_db_instance.this.id }
output "db_secret_arn" { value = aws_db_instance.this.master_user_secret[0].secret_arn }
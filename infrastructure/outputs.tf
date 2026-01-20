output "alb_dns_name" { value = module.compute_ecs.alb_dns_name }
output "app_url" { value = "http://${module.compute_ecs.alb_dns_name}/" }
output "health_url" { value = "http://${module.compute_ecs.alb_dns_name}${var.health_path}" }

output "ecs_cluster_name" { value = module.compute_ecs.cluster_name }
output "ecs_service_name" { value = module.compute_ecs.service_name }

output "db_endpoint" { value = module.database.db_endpoint }
output "s3_static_bucket" { value = module.storage.bucket_name }
module "network" {
  source               = "./modules/network"
  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  db_subnet_cidrs      = var.db_subnet_cidrs
  enable_s3_endpoint   = var.enable_vpc_endpoints
}

module "security" {
  source       = "./modules/security"
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.network.vpc_id
  app_port     = var.app_port
}

module "storage" {
  source       = "./modules/storage"
  project_name = var.project_name
  environment  = var.environment
}

module "database" {
  source       = "./modules/database"
  project_name = var.project_name
  environment  = var.environment

  db_engine         = var.db_engine
  db_engine_version = var.db_engine_version
  db_instance_class = var.db_instance_class
  db_allocated_gb   = var.db_allocated_gb
  db_name           = var.db_name

  db_subnet_ids = module.network.db_subnet_ids
  db_sg_id      = module.security.db_sg_id
  app_sg_id     = module.security.ecs_sg_id
}

module "compute_ecs" {
  source       = "./modules/compute_ecs"
  project_name = var.project_name
  environment  = var.environment

  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids

  alb_sg_id = module.security.alb_sg_id
  ecs_sg_id = module.security.ecs_sg_id

  app_port    = var.app_port
  health_path = var.health_path
  app_image   = var.app_image

  ecs_cpu       = var.ecs_cpu
  ecs_memory    = var.ecs_memory
  desired_count = var.desired_count
  max_count     = var.max_count

  enable_https = var.enable_https
  acm_cert_arn = var.acm_cert_arn

  db_endpoint   = module.database.db_endpoint
  db_port       = module.database.db_port
  db_secret_arn = module.database.db_secret_arn

  enable_vpc_endpoints = var.enable_vpc_endpoints
}

module "monitoring" {
  source       = "./modules/monitoring"
  project_name = var.project_name
  environment  = var.environment

  alb_arn_suffix  = module.compute_ecs.alb_arn_suffix
  tg_arn_suffix   = module.compute_ecs.tg_arn_suffix
  rds_instance_id = module.database.rds_instance_id

  alarm_email = var.alarm_email
}

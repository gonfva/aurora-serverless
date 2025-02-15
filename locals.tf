locals {
  slug = replace(lower(var.cluster_name), " ", "-")
  tags = merge(var.tags, {
    Name       = var.cluster_name
    Enviroment = var.environment_type
  })
  engine         = var.engine_type == "pg" ? "aurora-postgresql" : "aurora-mysql"
  engine_version = var.engine_type == "pg" ? "16.6" : "8.0.mysql_aurora.3.08.1"
  num_instances  = var.environment_type == "prod" ? 2 : 1
}

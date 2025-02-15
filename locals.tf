locals {
  slug = replace(lower(var.cluster_name), " ", "-")
  tags = merge(var.tags, {
    Name       = var.cluster_name
    Enviroment = var.environment_type
  })
  engine                    = var.engine_type == "pg" ? "aurora-postgresql" : "aurora-mysql"
  engine_version            = var.engine_type == "pg" ? "16.6" : "8.0.mysql_aurora.3.08.1"
  num_instances             = var.environment_type == "prod" ? 2 : 1
  final_snapshot_identifier = var.environment_type == "prod" ? "${local.slug}-final-snapshot" : null
  skip_final_snapshot       = var.environment_type == "prod" ? false : true
  backup_retention_period   = var.environment_type == "prod" ? 7 : 0
  port                      = var.engine_type == "pg" ? 5432 : 3306
}

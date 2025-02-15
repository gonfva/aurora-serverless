resource "random_password" "passwords" {
  for_each = var.db_users
  length   = 20
  special  = false
}

module "create_users" {
  source       = "./user-creation"
  db_users     = var.db_users
  db_name      = var.db_name
  db_passwords = { for k, v in random_password.passwords : k => v.result }
  vpc_id       = var.vpc_id
  subnet_ids   = var.subnet_ids
  db_endpoint  = aws_rds_cluster.cluster.endpoint
  db_sg        = aws_security_group.cluster_sg.id
  tags         = local.tags
  slug         = local.slug
  port         = local.port

  depends_on = [
    aws_rds_cluster.cluster,
    aws_rds_cluster_instance.instance
  ]
}

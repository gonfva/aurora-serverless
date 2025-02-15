resource "random_password" "passwords" {
  for_each = var.db_users
  length   = 20
  special  = false
}

module "user_updater" {
  source       = "./updater"
  db_users     = var.db_users
  db_name      = var.db_name
  db_passwords = local.db_passwords
  vpc_id       = var.vpc_id
  subnet_ids   = var.subnet_ids
  db_endpoint  = aws_rds_cluster.cluster.endpoint
  db_sg        = aws_security_group.cluster_sg.id
  tags         = local.tags
  slug         = local.slug
  port         = local.port
  package_path = local.package_path
}

resource "null_resource" "create_users" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
      aws lambda invoke \
        --region ${local.region} \
        --function-name ${module.user_updater.function_name} \
        --payload '{"users": [
          {"username": "${var.db_users.ro}", "password": "${local.db_passwords.ro}", "permissions" :"SELECT"},
          {"username": "${var.db_users.rw}", "password": "${local.db_passwords.rw}", "permissions" :"SELECT, INSERT, UPDATE, DELETE"}
        ]}' \
        ${local.results_path}
    EOT
  }

  depends_on = [
    aws_rds_cluster_instance.instance
  ]
}

data "local_file" "results" {
  filename = local.results_path

  depends_on = [
    null_resource.create_users
  ]
}

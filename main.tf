resource "aws_rds_cluster" "cluster" {
  cluster_identifier = local.slug
  engine             = local.engine
  engine_mode        = "provisioned"
  engine_version     = local.engine_version
  database_name      = var.db_name
  master_username    = var.db_users["admin"]
  master_password    = random_password.passwords["admin"].result
  storage_encrypted  = true #We don't speciy key for now
  #final_snapshot_identifier is required when skip_final_snapshot is false
  final_snapshot_identifier = local.final_snapshot_identifier
  skip_final_snapshot       = local.skip_final_snapshot
  backup_retention_period   = local.backup_retention_period

  tags = local.tags

  vpc_security_group_ids = [aws_security_group.cluster_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.subnets.id

  serverlessv2_scaling_configuration {
    max_capacity             = 1.0
    min_capacity             = 0.0
    seconds_until_auto_pause = 3600
  }
}

resource "aws_rds_cluster_instance" "instance" {
  count              = local.num_instances
  identifier         = "${local.slug}-${count.index}"
  cluster_identifier = aws_rds_cluster.cluster.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.cluster.engine
  engine_version     = aws_rds_cluster.cluster.engine_version
}

resource "aws_security_group" "cluster_sg" {
  name        = "db-${local.slug}"
  description = "Security group associated with the cluster ${local.slug}"
  vpc_id      = var.vpc_id

  tags = merge(local.tags, {
    Name = "db-${local.slug}"
  })
}

resource "aws_db_subnet_group" "subnets" {
  name       = local.slug
  subnet_ids = var.subnet_ids

  tags = local.tags
}

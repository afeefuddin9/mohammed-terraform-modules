/*
Useful references:

https://docs.aws.amazon.com/documentdb/latest/developerguide/db-instance-classes.html#db-instance-class-specs
https://docs.aws.amazon.com/documentdb/latest/developerguide/db-cluster-parameter-group-create.html
https://www.terraform.io/docs/providers/aws/r/docdb_cluster.html
https://www.terraform.io/docs/providers/aws/r/docdb_cluster_instance.html
https://www.terraform.io/docs/providers/aws/r/docdb_cluster_parameter_group.html
https://www.terraform.io/docs/providers/aws/r/docdb_subnet_group.html
https://docs.aws.amazon.com/documentdb/latest/developerguide/troubleshooting.html
*/
resource "aws_docdb_cluster" "DocDB_cluster" {
  cluster_identifier              = lower(var.envPrefix)
  master_username                 = var.master_username
  master_password                 = var.master_password
  backup_retention_period         = var.retention_period
  preferred_backup_window         = var.preferred_backup_window
  preferred_maintenance_window    = var.preferred_maintenance_window
  final_snapshot_identifier       = lower(var.identifier)
  skip_final_snapshot             = var.skip_final_snapshot
  deletion_protection             = var.deletion_protection
  apply_immediately               = var.apply_immediately
  storage_encrypted               = var.storage_encrypted
  #kms_key_id                      = var.kms_key_id
  port                            = var.db_port
  vpc_security_group_ids          = var.vpc_security_group_ids
  db_subnet_group_name            = aws_docdb_subnet_group.default.name
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.default.name
  engine                          = var.engine
  engine_version                  = var.engine_version
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  tags                            = var.default_tags
}
resource "aws_docdb_cluster_instance" "default" {
  identifier                 = lower(var.identifier)
  cluster_identifier         = aws_docdb_cluster.DocDB_cluster.id
  apply_immediately          = var.apply_immediately
  instance_class             = var.instance_class
  engine                     = var.engine
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  tags                       = var.default_tags
}
resource "aws_docdb_subnet_group" "default" {
  name        = lower("${var.identifier}-subnet_group")
  description = "Allowed subnets for DB cluster instances"
  subnet_ids  = var.subnet_ids
  tags        = var.default_tags
}
# https://docs.aws.amazon.com/documentdb/latest/developerguide/db-cluster-parameter-group-create.html
resource "aws_docdb_cluster_parameter_group" "default" {
  name        = lower(var.identifier)
  description = "DB cluster parameter group"
  family      = var.cluster_family

  dynamic "parameter" {
    for_each = var.cluster_parameters
    content {
      apply_method = lookup(parameter.value, "apply_method", null)
      name         = parameter.value.name
      value        = parameter.value.value
    }
  }
  tags        = var.default_tags
}

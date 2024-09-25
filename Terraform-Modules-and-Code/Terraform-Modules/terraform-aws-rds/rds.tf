# Creating the db subnet group
resource "aws_db_subnet_group" "rds-private-subnet" {
  name = var.aws_db_subnet_group_name
  subnet_ids = [var.rds_subnet1, var.rds_subnet2]
}
# Creating the rds db instance
resource "aws_db_instance" "mysql_db" {
  allocated_storage           = var.allocated_storage
  storage_type                = var.storage_type
  storage_encrypted           = var.storage_encrypted
  engine                      = var.engine
  engine_version              = var.engine_version
  instance_class              = var.instance_class
  name                        = var.db_name
  username                    = var.username
  password                    = var.password
  parameter_group_name        = var.parameter_group_name
  copy_tags_to_snapshot       = var.copy_tags_to_snapshot
  db_subnet_group_name        = aws_db_subnet_group.rds-private-subnet.name
  vpc_security_group_ids      = var.rds-sg
  identifier                  = var.identifier
  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  backup_retention_period     = var.backup_retention_period
  backup_window               = var.backup_window
  maintenance_window          = var.maintenance_window
  multi_az                    = var.multi_az
  performance_insights_enabled = var.performance_insights_enabled
  skip_final_snapshot         = var.skip_final_snapshot
  publicly_accessible         = var.publicly_accessible
  deletion_protection = var.deletion_protection
  enabled_cloudwatch_logs_exports = var.log_exports_type
  tags = var.default_tags
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  max_allocated_storage = var.max_allocated_storage
}
# Creating the db event subscription for notification
resource "aws_db_event_subscription" "default" {
  count = var.create_DB_event_subscription ? 1 : 0
  name      = "${var.envPrefix}-rds-event-sub"
  sns_topic = var.rds_sns_topic
  source_type = "db-instance"
  source_ids  = [aws_db_instance.mysql_db.id]
  event_categories = [
    "availability",
    "deletion",
    "failover",
    "failure",
    "low storage",
    "maintenance",
    "notification",
    "read replica",
    "recovery",
    "restoration",
  ]
}
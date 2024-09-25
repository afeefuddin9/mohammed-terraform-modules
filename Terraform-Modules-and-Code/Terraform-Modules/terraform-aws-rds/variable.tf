variable "region" {
  description = "the region of the db"
}
variable "aws_db_subnet_group_name" {
  description = "defines the env prefix"
}
variable "envPrefix" {
  description = "defines the env prefix"
}
variable "default_tags" {
  description = "defines the default tags"
}
variable "db_name" {
  description = "the db name"
}
variable "identifier" {
  description = "the unique db identifier"
}
variable "parameter_group_name" {
  description = "the parameter group name that need to used for db"
}
variable "max_allocated_storage" {
  description = "the max allocated storage"
  default = ""
}
variable "iam_database_authentication_enabled" {
 description = "Define whether to enable IAM database auth or not"
 default = false
 }
variable "copy_tags_to_snapshot" {
  description = "to copy the tags to snapshot"
  default = "true"
}
variable "performance_insights_enabled" {
  description = "Define whether to enable performance insights or not"
  default = "true"
}
variable "username" {
  description = "the db username"
}
variable "password" {
  description = "should asks for asks password promting"
}
variable "engine" {
  description = "the db engine name"
}
variable "engine_version" {
  description = "the db engine version"
}
variable "instance_class" {
  description = "the db instance class"
}
variable "allow_major_version_upgrade" {
  description = "boolean value to allow major version upgrade"
  default = "true"
}
variable "auto_minor_version_upgrade" {
  description = "boolean value to allow minor version upgrade"
  default = "true"
}
variable "allocated_storage" {
 description = "the storage that should be allocated"
}
variable "storage_type" {
  description = "the type of the storage"
}

variable "rds_subnet1" {
description = "the subnet id for db subnet group"
}
variable "rds_subnet2" {
  description = "the subnet id for db subnet group"
}
variable "multi_az" {
   default = "false"
   description = "boolean value to enable the multi az"
}
variable "rds-sg" {
  description = "the securities group id's of the rds"
  type        = list(string)
}
variable "backup_retention_period" {
  description = "the backup retention peroid"
  default = "35"
}
variable "backup_window" {
  description = "the backup timings"
  default = "22:00-23:00"
}
variable "maintenance_window" {
  description = "the timings to perform the maintenance"
  default = "Sat:00:00-Sat:03:00"
}
variable "skip_final_snapshot" {
  default = "false"
  description = "boolean value to skip the final snapshot"
}
variable "publicly_accessible" {
  default = "false"
  description = "boolean value to define whether public access needed or not"
}
variable "deletion_protection" {
  default = "true"
  description = "Boolean value to enable the deletion protection"
}
variable "log_exports_type" {
  description = "the type of logs needs to be stored"
  type        = list(string)
  default = []
}
variable "rds_sns_topic" {
  description = "name of the sns topic"
}
variable "create_DB_event_subscription" {
  description = "name of the sns topic"
  default = "false"
}
variable "storage_encrypted" {
  description = "name of the sns topic"
  default = "false"
}




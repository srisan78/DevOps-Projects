variable "cluster_identifier" {}
variable "engine_version" {}
variable "master_username" {}
variable "master_password" {}
variable "database_name" {}
variable "db_subnet_group_name" {}
variable "private_subnet1" {}
variable "private_subnet2" {}
variable "db_sg_id" {}
variable "instance_class" {
  default = "db.r5.large"
}
variable "read_replica_count" {
  default = 1
}

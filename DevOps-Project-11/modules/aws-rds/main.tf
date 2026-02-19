# -----------------------------
# 1️⃣ DB Subnet Group
# -----------------------------
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = var.db_subnet_group_name
  subnet_ids = [var.private_subnet1, var.private_subnet2]

  tags = {
    Name = var.db_subnet_group_name
  }
}

# -----------------------------
# 2️⃣ Aurora RDS Cluster
# -----------------------------
resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier      = var.cluster_identifier
  engine                  = "aurora-mysql"
  engine_version          = var.engine_version # Valid version: 8.0.mysql_aurora.3.12.0
  master_username         = var.master_username
  master_password         = var.master_password
  backup_retention_period = 7
  preferred_backup_window = "07:00-09:00"
  skip_final_snapshot     = true
  database_name           = var.database_name
  port                    = 3306
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [var.db_sg_id]

  tags = {
    Name = var.cluster_identifier
  }
}

# -----------------------------
# 3️⃣ Primary Cluster Instance
# -----------------------------
resource "aws_rds_cluster_instance" "primary_instance" {
  cluster_identifier = aws_rds_cluster.aurora_cluster.id
  identifier         = "${var.cluster_identifier}-primary"
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.aurora_cluster.engine
  engine_version     = aws_rds_cluster.aurora_cluster.engine_version
  publicly_accessible = false
}

# -----------------------------
# 4️⃣ Read Replica Cluster Instance
# -----------------------------
resource "aws_rds_cluster_instance" "read_replica_instance" {
  count              = var.read_replica_count
  cluster_identifier = aws_rds_cluster.aurora_cluster.id
  identifier         = "${var.cluster_identifier}-replica-${count.index}"
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.aurora_cluster.engine

  depends_on = [aws_rds_cluster_instance.primary_instance]
}

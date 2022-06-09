##
# The configuration for this backend will be filled in by Terragrunt
#
# https://terragrunt.gruntwork.io/docs/features/keep-your-remote-state-configuration-dry/
#
terraform {
  backend "s3" {}
}

#
# RDS
#
# https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/latest
#
module "db" {
  source  = "terraform-aws-modules/rds/aws"

  identifier = "${local.name}_rds_${var.deployment_id}"

  engine            = "mysql"
  engine_version    = "5.7.25"
  instance_class    = "db.t3a.large"
  allocated_storage = 5

  db_name  = "demodb"
  username = "user"
  port     = "3306"
  password = var.rds_password

  ###
  # To Do: Setup IAM Authentication from ec2 instance role
  ###
  #iam_database_authentication_enabled = false

  vpc_security_group_ids = ["${aws_security_group.SafRdsSG.id}"]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval = "30"
  monitoring_role_name = "MyRDSMonitoringRole"
  create_monitoring_role = true

  tags = {
    Name = "${local.name}-${var.deployment_id}",
    Owner   = basename(data.aws_caller_identity.current.arn),
    Project = local.name,
  }

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = var.subnet_ids

  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

  # Database Deletion Protection
  deletion_protection = true

  parameters = [
    {
      name = "character_set_client"
      value = "utf8mb4"
    },
    {
      name = "character_set_server"
      value = "utf8mb4"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}

##
##
# Security group that enables communication between EC2 and RDS
#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
#
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg-${var.deployment_id}"
  description = "Allow port 3306 communication with own SG"
  vpc_id      = var.vpc_id

  tags = {
    Name = "rds_sg-${var.deployment_id}",
    Owner   = basename(data.aws_caller_identity.current.arn),
    Project = local.name,
  }
}
provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Name            = "tofu-rds"
      ManagedBy       = "OpenTofu"
    }
  }
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.0"

  name                 = "rds"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "random_pet" "name" {
  length = 1
}

resource "aws_db_subnet_group" "rds" {
  name       = "${random_pet.name.id}-rds"
  subnet_ids = module.vpc.public_subnets

  tags = {
    Name = "rds"
  }
}

resource "aws_security_group" "rds" {
  name   = "${random_pet.name.id}_rds_rds"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds_rds"
  }
}

resource "aws_db_parameter_group" "rds" {
  name_prefix = "${random_pet.name.id}-rds"
  family      = "postgres15"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  # use this when upgrading from postgres15 to postgres16
/*  lifecycle {
    create_before_destroy     = true
  }
*/  
}

resource "aws_db_instance" "rds" {
  identifier                  = "${random_pet.name.id}rds"
  instance_class              = "db.t3.micro"
  allocated_storage           = 10
  apply_immediately           = true
  engine                      = "postgres"
  engine_version              = "15" # increment when upgrading
  username                    = "pguser"
  password                    = var.db_password
  allow_major_version_upgrade = true
  db_subnet_group_name        = aws_db_subnet_group.rds.name
  vpc_security_group_ids      = [aws_security_group.rds.id]
  parameter_group_name        = aws_db_parameter_group.rds.name
  publicly_accessible         = true
  skip_final_snapshot         = true
  backup_retention_period     = 1
}

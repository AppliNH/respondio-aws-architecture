

resource "aws_db_subnet_group" "db_subnet_grp" {
  name_prefix = "${var.context_name}-mysqldb-subnet-grp-"
  subnet_ids  = var.subnet_ids
  tags = {
    Name  = "${var.context_name}-mysqldb-subnet-grp"
    APP   = var.context_name
    STAGE = var.stage
  }
}

resource "aws_security_group" "mysql_db_sg" {
  name_prefix = "${var.context_name}-mysqldb-sg-"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    APP   = var.context_name
    STAGE = var.stage
  }
}

resource "aws_db_instance" "mysql_db" {
  identifier        = "${var.context_name}-mysqldb"
  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t2.micro"
  allocated_storage = 10

  db_name  = var.db_name
  username = var.credentials.username
  password = var.credentials.password

  db_subnet_group_name = aws_db_subnet_group.db_subnet_grp.name


  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.mysql_db_sg.id]

  tags = {
    Name  = "${var.context_name}-mysqldb"
    APP   = var.context_name
    STAGE = var.stage
  }
}

module "rds_policy" {
  source                  = "../../policies/rds_app_policy"
  target_resources_policy = ["${aws_db_instance.mysql_db.arn}"]
  role_name               = var.app_role_name
  db_name                 = var.db_name
}

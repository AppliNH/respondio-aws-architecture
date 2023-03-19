locals {
  context_name = "webapp"
}

# --- Networking

module "webapp_networking" {
  source          = "../../modules/networking/standard_vpc"
  context_name    = local.context_name
  stage           = var.stage
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
}

# ---

# --- Security Groups

resource "aws_security_group" "webapp_elb_sg" {
  name_prefix = "webapp-elb-sg-"
  vpc_id      = module.webapp_networking.vpc.id
  ingress {
    from_port   = var.elb_ingress.from_port
    to_port     = var.elb_ingress.to_port
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
    APP   = local.context_name
    STAGE = var.stage
  }
}

# ---

# --- EC2 Base role & Cloud Watch

resource "aws_iam_role" "webapp_vm_role" {
  name = "webapp-vm-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

module "webapp_cloudwatch_write_logs_policy" {
  source = "../../modules/policies/cloudwatch_app_write_logs_policy"
  target_resources_policy = [
    "arn:aws:ec2:*:*:instance/*",
    "arn:aws:ec2:*:*:network-interface/*"
  ]
  role_name = aws_iam_role.webapp_vm_role.name
}

# ---

# --- RDS

module "webapp_mysql_db" {
  source        = "../../modules/services/mysql_db"
  app_role_name = aws_iam_role.webapp_vm_role.name
  db_name       = var.db_name
  credentials = {
    username = "admin"
    password = "password"
  }

  vpc_id = module.webapp_networking.vpc.id

  stage        = var.stage
  context_name = local.context_name
  subnet_ids   = [for v in module.webapp_networking.private_subnets : v.id]
}

# ---

# --- S3

module "webapp_s3_bucket" {
  source = "../../modules/services/s3_bucket"

  app_role_name = aws_iam_role.webapp_vm_role.name
  stage         = "PRD"
  context_name  = "webapp"

}

# ---

# --- LB
resource "aws_elb" "webapp_elb" {
  name            = "webapp-elb"
  security_groups = [aws_security_group.webapp_elb_sg.id]
  subnets         = [for item in module.webapp_networking.public_subnets : item.id]
  listener {
    instance_port     = var.elb_listener.instance_port
    instance_protocol = "http"
    lb_port           = var.elb_listener.lb_port
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    target              = "HTTP:80/"
    timeout             = 5
  }
}

# ---

# --- EC2

module "webapp_autoscaling_group" {
  source = "../../modules/services/autoscaling_ec2"

  app_ingress = {
    from_port = 8080
    to_port   = 8080
  }

  sizes = {
    desired_capacity = 4
    max_size         = 10
    min_size         = 2
  }

  app_role_name = aws_iam_role.webapp_vm_role.name

  stage        = "PRD"
  context_name = "webapp"
  image_id     = "ami-05bfef86a955a699e"

  instance_type = "t3.small"

  vpc_id = module.webapp_networking.vpc.id

  subnet_ids = [for v in module.webapp_networking.private_subnets : v.id]

}


resource "aws_autoscaling_attachment" "webapp_elb_attachment_bar" {
  autoscaling_group_name = module.webapp_autoscaling_group.autoscaling_group.id
  elb                    = aws_elb.webapp_elb.id
}

# ---

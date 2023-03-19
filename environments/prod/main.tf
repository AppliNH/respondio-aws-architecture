provider "aws" {
  region  = "eu-west-3"
  profile = "terraform"
}

# --- Network

resource "aws_vpc" "webapp_vpc" {
  cidr_block = "10.0.0.0/16"


  tags = {
    Name  = "webapp-vpc"
    APP   = "WEBAPP"
    STAGE = "PRD"
  }
}

# Create internet gateway
resource "aws_internet_gateway" "webapp_internet_gtw" {
  vpc_id = aws_vpc.webapp_vpc.id
}


data "aws_availability_zones" "available" {}

locals {
  private_subnets = [
    {
      cidr_block = "10.0.1.0/24",
    },
    {
      cidr_block = "10.0.2.0/24",
  }]
  public_subnets = [
    {
      cidr_block = "10.0.3.0/24",
    },
    {
      cidr_block = "10.0.4.0/24",
    },
  ]

  webapp_db_dbname = "webappdbdata"
}

resource "aws_subnet" "webapp_private_subnets" {
  for_each = {
    for index, subnet in local.private_subnets :
    index => subnet
  }

  vpc_id                  = aws_vpc.webapp_vpc.id
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = false

  availability_zone = element(data.aws_availability_zones.available.names, each.key)

  tags = {
    Name  = "webapp-private-${each.key}"
    APP   = "WEBAPP"
    STAGE = "PRD"
  }

}

resource "aws_subnet" "webapp_public_subnets" {
  for_each = {
    for index, subnet in local.public_subnets :
    index => subnet
  }

  vpc_id                  = aws_vpc.webapp_vpc.id
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = true

  availability_zone = element(data.aws_availability_zones.available.names, each.key)

  tags = {
    Name  = "webapp-public-${each.key}"
    APP   = "WEBAPP"
    STAGE = "PRD"
  }

}

resource "aws_route_table" "webapp_public_rt" {
  vpc_id = aws_vpc.webapp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.webapp_internet_gtw.id
  }

  tags = {
    APP   = "WEBAPP"
    STAGE = "PRD"
  }
}


resource "aws_route_table_association" "public_subnet_association" {

  for_each = {
    for index, item in aws_subnet.webapp_public_subnets :
    index => item
  }

  subnet_id      = each.value.id
  route_table_id = aws_route_table.webapp_public_rt.id

}


# ---

# --- Security Groups


resource "aws_security_group" "webapp_vm_sg" {
  name_prefix = "webapp-vm-sg-"
  vpc_id      = aws_vpc.webapp_vpc.id
  ingress {
    from_port   = 8080
    to_port     = 8080
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
    APP   = "WEBAPP"
    STAGE = "PRD"
  }
}

resource "aws_security_group" "webapp_elb_sg" {
  name_prefix = "webapp-elb-sg-"
  vpc_id      = aws_vpc.webapp_vpc.id
  ingress {
    from_port   = 443
    to_port     = 443
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
    APP   = "WEBAPP"
    STAGE = "PRD"
  }
}


resource "aws_security_group" "webapp_db_sg" {
  name_prefix = "webapp-db-sg-"
  vpc_id      = aws_vpc.webapp_vpc.id
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
    APP   = "WEBAPP"
    STAGE = "PRD"
  }
}


# ---

# --- Roles & policies

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

resource "aws_iam_policy" "cloudwatch_write_logs_policy" {
  name = "cloudwatch-write-logs-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:ec2:*:*:instance/*",
          "arn:aws:ec2:*:*:network-interface/*"
        ]
      }
    ]
  })
}


resource "aws_iam_policy" "webapp_bucket_policy" {
  name = "webapp-bucket-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "${aws_s3_bucket.webapp_bucket.arn}",
          "${aws_s3_bucket.webapp_bucket.arn}/*"
        ]
      }
    ]
  })
}

output "db_arn" {
  value = aws_db_instance.webapp_db.arn
}

resource "aws_iam_policy" "webapp_db_policy" {
  name = "webapp-db-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "rds-db:connect",
          "rds-data:ExecuteStatement",
          "rds-data:BatchExecuteStatement",
          "rds-data:BeginTransaction",
          "rds-data:CommitTransaction",
          "rds-data:RollbackTransaction"
        ],
        Resource = [
          "${aws_db_instance.webapp_db.arn}"
        ]
        Condition = {
          StringEquals = {
            "rds:DatabaseName" = local.webapp_db_dbname
          }
        }
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "cloudwatch_webapp_role_policy_attach" {
  policy_arn = aws_iam_policy.cloudwatch_write_logs_policy.arn
  role       = aws_iam_role.webapp_vm_role.name
}

resource "aws_iam_role_policy_attachment" "bucket_webapp_role_policy_attach" {
  policy_arn = aws_iam_policy.webapp_bucket_policy.arn
  role       = aws_iam_role.webapp_vm_role.name
}

resource "aws_iam_role_policy_attachment" "db_webapp_role_policy_attach" {
  policy_arn = aws_iam_policy.webapp_db_policy.arn
  role       = aws_iam_role.webapp_vm_role.name
}

resource "aws_iam_instance_profile" "webapp_vm_instance_profile" {
  role = aws_iam_role.webapp_vm_role.name
}


# ---

# --- RDS

resource "aws_db_subnet_group" "webapp_db_subnet_grp" {
  name_prefix = "webapp-db-subnet-grp-"
  subnet_ids  = [for v in aws_subnet.webapp_private_subnets : v.id]
  tags = {
    Name  = "webapp-db-subnet-grp"
    APP   = "WEBAPP"
    STAGE = "PRD"
  }
}


resource "aws_db_instance" "webapp_db" {
  identifier        = "webapp-db"
  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t2.micro"
  allocated_storage = 10

  db_name  = local.webapp_db_dbname
  username = "admin"
  password = "password"

  db_subnet_group_name = aws_db_subnet_group.webapp_db_subnet_grp.name


  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.webapp_db_sg.id]

  tags = {
    Name  = "webapp-db"
    APP   = "WEBAPP"
    STAGE = "PRD"
  }
}

# ---

# --- S3

resource "aws_s3_bucket" "webapp_bucket" {
  bucket_prefix = "webapp-bucket-"

  tags = {
    Name  = "webapp-bucket"
    APP   = "WEBAPP"
    STAGE = "PRD"

  }
}

resource "aws_s3_bucket_acl" "webapp_bucket_acl" {
  bucket = aws_s3_bucket.webapp_bucket.id
  acl    = "private"
}

# ---

# --- LB
resource "aws_elb" "webapp_elb" {
  name            = "webapp-elb"
  security_groups = [aws_security_group.webapp_elb_sg.id]
  subnets         = [for item in aws_subnet.webapp_public_subnets : item.id]
  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
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

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.webapp_vm_scale_group.id
  elb                    = aws_elb.webapp_elb.id
}

# ---

# --- Route53

resource "aws_route53_zone" "webapp_zone" {
  name = "webapp.sg"
}

resource "aws_route53_record" "webapp_alias" {
  zone_id = aws_route53_zone.webapp_zone.id
  name    = "webapp.sg"
  type    = "A"
  alias {
    name                   = aws_elb.webapp_elb.dns_name
    zone_id                = aws_elb.webapp_elb.zone_id
    evaluate_target_health = true
  }
}



# ---

# --- EC2

resource "aws_placement_group" "webapp_vm_placement_group" {
  name     = "webapp-vm-placement-group"
  strategy = "partition"


  tags = {
    APP   = "WEBAPP"
    STAGE = "PRD"
  }
}


resource "aws_launch_template" "webapp_vm_template" {
  name_prefix   = "webapp-vm-"
  image_id      = "ami-05bfef86a955a699e" # Debian 11
  instance_type = "t3.small"



  vpc_security_group_ids = [aws_security_group.webapp_vm_sg.id]

  iam_instance_profile {
    arn = aws_iam_instance_profile.webapp_vm_instance_profile.arn
  }

  tags = {
    APP   = "WEBAPP"
    STAGE = "PRD"
  }
}



resource "aws_autoscaling_group" "webapp_vm_scale_group" {
  name = "webapp-vm-scale-group"

  max_size                  = 10
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 4
  force_delete              = true
  placement_group           = aws_placement_group.webapp_vm_placement_group.id
  vpc_zone_identifier       = [for v in aws_subnet.webapp_private_subnets : v.id]


  launch_template {
    id      = aws_launch_template.webapp_vm_template.id
    version = "$Latest"
  }


  tag {
    key                 = "APP"
    value               = "WEBAPP"
    propagate_at_launch = true
  }

  tag {
    key                 = "STAGE"
    value               = "PRD"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }

}

# ---

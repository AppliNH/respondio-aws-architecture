provider "aws" {
  region  = "eu-west-3"
  profile = "terraform"
}

locals {
  webapp_db_dbname = "webappdbprd"
  stage            = "PRD"
}

# --- WebApp

module "webapp" {
  stage  = local.stage
  source = "../../applications/webapp"

  db_name = local.webapp_db_dbname

  elb_listener = {
    instance_port = 8080
    lb_port       = 80
  }
  elb_ingress = {
    from_port = 80
    to_port   = 80
  }

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
    name                   = module.webapp.elb.dns_name
    zone_id                = module.webapp.elb.zone_id
    evaluate_target_health = true
  }
}

# ---


variable "public_subnets" {
  type = list(object({
    cidr_block = string
  }))
  description = "List of objects containing details for public subnets."
}

variable "private_subnets" {
  type = list(object({
    cidr_block = string
  }))
  description = "List of objects containing details for public subnets."
}

variable "stage" {
  type        = string
  description = "Deployment stage name (eg: PRD, STG, SANDBOX, QA, etc)."
  # We can also enforce specific values here by using validators !
}

variable "elb_listener" {
  type = object({
    instance_port = number
    lb_port       = number
  })
  description = "Listening front and back ports for ELB."
}

variable "elb_ingress" {
  type = object({
    from_port = number
    to_port   = number
  })
  description = "Port numbers for ELB ingress (from_port & to_port)."
}

variable "db_name" {
  type        = string
  description = "Name of the db."
}

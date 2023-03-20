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

variable "context_name" {
  type        = string
  description = "Name of the current context to create networking resources (eg: an app name)."
}

variable "stage" {
  type        = string
  description = "Deployment stage name (eg: PRD, STG, SANDBOX, QA, etc)."
  # We can also enforce specific values here by using validators !
}

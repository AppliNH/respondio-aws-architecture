
variable "credentials" {
  type = object({
    username = string
    password = string
  })
  description = "Username & password pair for db credentials."
  sensitive   = true
}


variable "vpc_id" {
  type        = string
  description = "ID of the vpc to bind the db to."
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet ids for the db."
}

variable "app_role_name" {
  type        = string
  description = "Name of the role that will access db."
}

variable "db_name" {
  type        = string
  description = "Name of the db to give access to"
}


variable "context_name" {
  type        = string
  description = "Name of the current context to create networking resources (eg: an app name)"
}

variable "stage" {
  type        = string
  description = "Deployment stage name (eg: PRD, STG, SANDBOX, QA, etc)"
  # We can also enforce specific values here by using validators !
}

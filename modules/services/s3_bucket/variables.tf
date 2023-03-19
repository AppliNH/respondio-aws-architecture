variable "app_role_name" {
  type        = string
  description = "Name of the role that will access db."
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

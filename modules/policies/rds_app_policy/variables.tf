variable "target_resources_policy" {
  type        = list(string)
  description = "Target resources for the policy (value can be wildcard *)."
}

variable "db_name" {
  type        = string
  description = "Name of the db to give access to."
}

variable "role_name" {
  type        = string
  description = "Name of the role to attach the policy to."
}

variable "role_name" {
  type        = string
  description = "Name of the role"

  validation {
    condition     = length(var.role_name) > 1
    error_message = "role_name can't be empty"
  }
}

variable "target_service" {
  type        = string
  descirption = "Target service for the role policy (eg: ec2.amazonaws.com)"

}

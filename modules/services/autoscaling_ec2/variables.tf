variable "image_id" {
  type        = string
  description = "ID of the image for the EC2 launch template."
}

variable "instance_type" {
  type        = string
  description = "Type of EC2 instance."
}

variable "sizes" {
  type = object({
    max_size         = number
    min_size         = number
    desired_capacity = number
  })
  description = "Figures in terms of nbers of EC2 for autoscaling configuration."
}

variable "vpc_id" {
  type        = string
  description = "ID of the vpc to bind the group to."
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet ids for the scaling group."
}

variable "app_ingress" {
  type = object({
    from_port = number
    to_port   = number
  })
  description = "Port numbers for ELB ingress (from_port & to_port)."

}

variable "app_role_name" {
  type        = string
  description = "Name of the role to bind the EC2 instances to."
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

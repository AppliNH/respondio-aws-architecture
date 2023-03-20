# `autoscaling_ec2` module

Provisions an autoscaling EC2 group with custom and flexible parameters, using a security group.

## Requirements

No requirements.

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | n/a     |

## Modules

No modules.

## Resources

| Name                                                                                                                                             | Type     |
| ------------------------------------------------------------------------------------------------------------------------------------------------ | -------- |
| [aws_autoscaling_group.vm_scale_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group)            | resource |
| [aws_iam_instance_profile.vm_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_launch_template.vm_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template)                   | resource |
| [aws_security_group.vm_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                           | resource |

## Inputs

| Name                                                                     | Description                                                                   | Type                                                                                                 | Default | Required |
| ------------------------------------------------------------------------ | ----------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- | ------- | :------: |
| <a name="input_app_ingress"></a> [app_ingress](#input_app_ingress)       | Port numbers for ELB ingress (from_port & to_port).                           | <pre>object({<br> from_port = number<br> to_port = number<br> })</pre>                               | n/a     |   yes    |
| <a name="input_app_role_name"></a> [app_role_name](#input_app_role_name) | Name of the role to bind the EC2 instances to.                                | `string`                                                                                             | n/a     |   yes    |
| <a name="input_context_name"></a> [context_name](#input_context_name)    | Name of the current context to create networking resources (eg: an app name). | `string`                                                                                             | n/a     |   yes    |
| <a name="input_image_id"></a> [image_id](#input_image_id)                | ID of the image for the EC2 launch template.                                  | `string`                                                                                             | n/a     |   yes    |
| <a name="input_instance_type"></a> [instance_type](#input_instance_type) | Type of EC2 instance.                                                         | `string`                                                                                             | n/a     |   yes    |
| <a name="input_sizes"></a> [sizes](#input_sizes)                         | Figures in terms of nbers of EC2 for autoscaling configuration.               | <pre>object({<br> max_size = number<br> min_size = number<br> desired_capacity = number<br> })</pre> | n/a     |   yes    |
| <a name="input_stage"></a> [stage](#input_stage)                         | Deployment stage name (eg: PRD, STG, SANDBOX, QA, etc).                       | `string`                                                                                             | n/a     |   yes    |
| <a name="input_subnet_ids"></a> [subnet_ids](#input_subnet_ids)          | Subnet ids for the scaling group.                                             | `list(string)`                                                                                       | n/a     |   yes    |
| <a name="input_vpc_id"></a> [vpc_id](#input_vpc_id)                      | ID of the vpc to bind the group to.                                           | `string`                                                                                             | n/a     |   yes    |

## Outputs

| Name                                                                                   | Description |
| -------------------------------------------------------------------------------------- | ----------- |
| <a name="output_autoscaling_group"></a> [autoscaling_group](#output_autoscaling_group) | n/a         |

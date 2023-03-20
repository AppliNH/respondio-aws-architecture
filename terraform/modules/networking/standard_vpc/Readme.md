# `standard_vpc` module

Provisions a complete VPC with as many public/private subnets as desired.

Also provisions an internet gateway, and routes all public subnet to it.

## Requirements

No requirements.

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | n/a     |

## Modules

No modules.

## Resources

| Name                                                                                                                                                         | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| [aws_internet_gateway.internet_gtw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)                            | resource    |
| [aws_route_table.public_rt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)                                         | resource    |
| [aws_route_table_association.public_subnet_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource    |
| [aws_subnet.private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                             | resource    |
| [aws_subnet.public_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                              | resource    |
| [aws_vpc.main_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)                                                          | resource    |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones)                        | data source |

## Inputs

| Name                                                                           | Description                                                                   | Type                                                     | Default | Required |
| ------------------------------------------------------------------------------ | ----------------------------------------------------------------------------- | -------------------------------------------------------- | ------- | :------: |
| <a name="input_context_name"></a> [context_name](#input_context_name)          | Name of the current context to create networking resources (eg: an app name). | `string`                                                 | n/a     |   yes    |
| <a name="input_private_subnets"></a> [private_subnets](#input_private_subnets) | List of objects containing details for public subnets.                        | <pre>list(object({<br> cidr_block = string<br> }))</pre> | n/a     |   yes    |
| <a name="input_public_subnets"></a> [public_subnets](#input_public_subnets)    | List of objects containing details for public subnets.                        | <pre>list(object({<br> cidr_block = string<br> }))</pre> | n/a     |   yes    |
| <a name="input_stage"></a> [stage](#input_stage)                               | Deployment stage name (eg: PRD, STG, SANDBOX, QA, etc).                       | `string`                                                 | n/a     |   yes    |

## Outputs

| Name                                                                             | Description |
| -------------------------------------------------------------------------------- | ----------- |
| <a name="output_private_subnets"></a> [private_subnets](#output_private_subnets) | n/a         |
| <a name="output_public_subnets"></a> [public_subnets](#output_public_subnets)    | n/a         |
| <a name="output_vpc"></a> [vpc](#output_vpc)                                     | n/a         |

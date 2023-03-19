# `mysql_db` module

Provisions a mysql database using AWS RDS, on a given subnet, along with a security group.

Also creates a policy to interact with the DB and assigns it to the given role.

## Requirements

No requirements.

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | n/a     |

## Modules

| Name                                                              | Source                        | Version |
| ----------------------------------------------------------------- | ----------------------------- | ------- |
| <a name="module_rds_policy"></a> [rds_policy](#module_rds_policy) | ../../policies/rds_app_policy | n/a     |

## Resources

| Name                                                                                                                             | Type     |
| -------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [aws_db_instance.mysql_db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance)              | resource |
| [aws_db_subnet_group.db_subnet_grp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_security_group.mysql_db_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)     | resource |

## Inputs

| Name                                                                     | Description                                                                  | Type                                                                   | Default | Required |
| ------------------------------------------------------------------------ | ---------------------------------------------------------------------------- | ---------------------------------------------------------------------- | ------- | :------: |
| <a name="input_app_role_name"></a> [app_role_name](#input_app_role_name) | Name of the role that will access db.                                        | `string`                                                               | n/a     |   yes    |
| <a name="input_context_name"></a> [context_name](#input_context_name)    | Name of the current context to create networking resources (eg: an app name) | `string`                                                               | n/a     |   yes    |
| <a name="input_credentials"></a> [credentials](#input_credentials)       | Username & password pair for db credentials.                                 | <pre>object({<br> username = string<br> password = string<br> })</pre> | n/a     |   yes    |
| <a name="input_db_name"></a> [db_name](#input_db_name)                   | Name of the db to give access to                                             | `string`                                                               | n/a     |   yes    |
| <a name="input_stage"></a> [stage](#input_stage)                         | Deployment stage name (eg: PRD, STG, SANDBOX, QA, etc)                       | `string`                                                               | n/a     |   yes    |
| <a name="input_subnet_ids"></a> [subnet_ids](#input_subnet_ids)          | Subnet ids for the db.                                                       | `list(string)`                                                         | n/a     |   yes    |
| <a name="input_vpc_id"></a> [vpc_id](#input_vpc_id)                      | ID of the vpc to bind the db to.                                             | `string`                                                               | n/a     |   yes    |

## Outputs

No outputs.

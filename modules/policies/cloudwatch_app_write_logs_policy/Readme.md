# `cloudwatch_app_write_logs_policy` module

Creates a Cloudwatch policy that allows an app to write logs.

Also assigns it to a given role.

## Requirements

No requirements.

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | n/a     |

## Modules

No modules.

## Resources

| Name                                                                                                                                                                                     | Type     |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [aws_iam_policy.cloudwatch_app_write_logs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                                                | resource |
| [aws_iam_role_policy_attachment.cloudwatch_app_write_logs_policy_attach_to_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name                                                                                                   | Description                                                 | Type           | Default | Required |
| ------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------- | -------------- | ------- | :------: |
| <a name="input_role_name"></a> [role_name](#input_role_name)                                           | Name of the role to attach the policy to.                   | `string`       | n/a     |   yes    |
| <a name="input_target_resources_policy"></a> [target_resources_policy](#input_target_resources_policy) | Target resources for the policy (value can be wildcard \*). | `list(string)` | n/a     |   yes    |

## Outputs

No outputs.

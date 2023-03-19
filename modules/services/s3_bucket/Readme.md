# `s3_bucket` module

Provisions a S3 bucket with private ACL.

Also creates a policy to interact with it and assigns it to the given role.

## Requirements

No requirements.

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | n/a     |

## Modules

| Name                                                                       | Source                              | Version |
| -------------------------------------------------------------------------- | ----------------------------------- | ------- |
| <a name="module_bucket_policy"></a> [bucket_policy](#module_bucket_policy) | ../../policies/s3_bucket_app_policy | n/a     |

## Resources

| Name                                                                                                                      | Type     |
| ------------------------------------------------------------------------------------------------------------------------- | -------- |
| [aws_s3_bucket.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)             | resource |
| [aws_s3_bucket_acl.bucket_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |

## Inputs

| Name                                                                     | Description                                                                  | Type     | Default | Required |
| ------------------------------------------------------------------------ | ---------------------------------------------------------------------------- | -------- | ------- | :------: |
| <a name="input_app_role_name"></a> [app_role_name](#input_app_role_name) | Name of the role that will access db.                                        | `string` | n/a     |   yes    |
| <a name="input_context_name"></a> [context_name](#input_context_name)    | Name of the current context to create networking resources (eg: an app name) | `string` | n/a     |   yes    |
| <a name="input_stage"></a> [stage](#input_stage)                         | Deployment stage name (eg: PRD, STG, SANDBOX, QA, etc)                       | `string` | n/a     |   yes    |

## Outputs

No outputs.

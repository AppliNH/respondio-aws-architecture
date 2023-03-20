# Terraform

## Use this project

This project uses Terraform workspaces, and they are located in the `environments/` folder.

Each sub-folders is a workspace

After cloning this project :

- `cd environments/<workspace-dir-name>`
- `terraform workspace new <workspace-dir-name>`
- `terraform init`
- and then you can run `terraform refresh`, `terraform plan` & `terraform apply` commands.

**Please note:** This project is a demo. Thus the tfstate file is not stored in a back-end (S3 bucket for eg).

## Write documentation

If you create/update new modules, please generate documentation with [`terraform-docs`](https://github.com/terraform-docs/terraform-docs).

## Folders structure

```
├── applications <-- Applications infrastructure (also called applicative modules), may use multiple modules.
│   ├── webapp
├── environments <-- Terraform workspaces per deployment stage (environment), will use applicative modules.
│   ├── webapp-prod <-- Terraform workspace
├── modules <-- Custom modules (also called technical modules)
│   ├── networking <-- Modules are separated per thematics.
│   ├── policies
│   ├── services
│   │   ├── autoscaling_ec2 <-- Module.
│   │   ├── mysql_db
│   │   ├── s3_bucket
```

This folder approach allows to separate **"application-centric"** and **"technical-centric"** modules, for better reusability.

A **application module** will use one or many **technical modules**, and will then be used for a specific environment in the `environments/` sub-folders, allowing to benefit of Terrafom workspaces.

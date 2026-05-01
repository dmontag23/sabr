# HCP Terraform

Terraform for **HashiCorp Cloud Platform (HCP) Terraform** resources: organizations, workspaces, variables, VCS settings, and anything else exposed by the [`hashicorp/tfe`](https://registry.terraform.io/providers/hashicorp/tfe/latest) provider.

## Requirements

- Terraform `>= 1.14`
- A [user or team API token](https://developer.hashicorp.com/terraform/cloud-docs/users-teams-organizations/api-tokens) exported as `TFE_TOKEN` (or `TF_TOKEN_app_terraform_io`) when you run `terraform` locally against this stack

## Commands

```bash
cd infra/hcp-terraform
terraform init
terraform plan
terraform apply
```

After changing provider versions, run `terraform init -upgrade` and commit the updated `.terraform.lock.hcl` if you add one.

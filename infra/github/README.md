# GitHub

Manages GitHub resources for the `sabr` repo.

## State and execution

- Terraform state is stored in the [HCP Terraform](https://app.terraform.io/) workspace `sabr-github` (org `sabs-apps`).
- This workspace is maintained in [sabr.tf](/infra//hcp-terraform/sabr.tf).

## Authentication

- The GitHub provider uses a `github_token` (see [providers.tf](./providers.tf)), which is a workspace variable is managed by the HCP `sabr-github` Terraform stack.

## Usage

```bash
cd infra/github
terraform init
terraform plan
terraform apply
```

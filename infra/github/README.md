# GitHub

Manages GitHub resources for the `sabr` repo.

## State and execution

- Terraform state is stored in the [HCP Terraform](https://app.terraform.io/) workspace `sabr-github` (org `sabs-apps`).
- This workspace is maintained in [/infra/hcp-terraform/workspaces.tf](/infra/hcp-terraform/workspaces.tf).

## What this stack manages

- Repository configuration and branch ruleset for the sabr app
- `staging` and `production` GitHub environments & branch deployment policies
- Repo & environment secrets for Supabase migrations

## Authentication

- The GitHub provider uses a `GITHUB_TOKEN` environment variable, which is a workspace variable managed by the HCP `sabr-github` Terraform stack.
- The `tfe` provider (for cross-workspace outputs) uses `TFE_TOKEN`,
  which is also a workspace variable managed by the HCP `sabr-github` Terraform stack.

## Dependency

`infra/hcp-terraform` must have applied successfully so the following outputs are available:

- `environment_names`
- `sabr_supabase_environment_names`

`infra/supabase` must also have applied successfully at least once per environment so the following outputs are available:

- `project_id`
- `database_password`

## Usage

```bash
cd infra/github
terraform init
terraform plan
terraform apply
```

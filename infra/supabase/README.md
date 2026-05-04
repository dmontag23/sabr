# Supabase

Manages the Supabase project for the `sabr` app.

## What this module manages

- Supabase project creation via `supabase_project.sabr`
- Database password generation and rotation every 30 days

## Required inputs

- `organization_id` (Supabase organization id)
- `project_name`

Optional:

- `project_region` (default: `us-west-2`)

## Before you run Terraform

Create a Supabase personal access token in **Account preferences -> Access Tokens**, then export:

```bash
export SUPABASE_ACCESS_TOKEN="<your-supabase-token>"
export TF_VAR_organization_id="<your-supabase-org-id>"
export TF_VAR_project_name="sabr-<environment name>"
```

`TF_VAR_organization_id` is the `org_...` value from your Supabase org URL/settings.
Use `sabr-staging` or `sabr-prod` as the project name for this repository's managed environments.

## Day-to-day usage

```bash
cd infra/supabase
terraform init
terraform plan
terraform apply
```

## First-time setup or recovery

See the [runbook](./RUNBOOK.md).

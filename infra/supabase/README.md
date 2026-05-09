# Supabase

Manages the Supabase projects for the `sabr` app.

## What this stack manages

- Supabase project via (`supabase_project.sabr`)
- Database password generation and rotation (default 30 days)
- Outputs consumed by `infra/github`:
  - `project_id`
  - `database_password` (sensitive)

## Required inputs

- `organization_id` (Supabase organization id)
- `project_name`

Optional:

- `project_region` (default: `eu-west-2`)

## Before you run Terraform

Create a Supabase personal access token in **Account preferences -> Access Tokens**, then export:

```bash
export SUPABASE_ACCESS_TOKEN="<your-supabase-token>"
export TF_VAR_organization_id="<your-supabase-org-id>"
export TF_VAR_project_name="sabr-<environment name>"
```

`TF_VAR_organization_id` is the `org_...` value from the Supabase organization in the URL (also in the settings).

In HCP Terraform, this same root configuration is used by two workspaces:

- `sabr-supabase-staging`
- `sabr-supabase-production`

Environment differences are provided via workspace variables.

## Day-to-day usage

For local CLI runs, select the target remote workspace first:

```bash
terraform workspace select sabr-supabase-staging
# or
terraform workspace select sabr-supabase-production
```

```bash
cd infra/supabase
terraform init
terraform plan
terraform apply
```

## First-time setup or recovery

See the [runbook](./RUNBOOK.md).

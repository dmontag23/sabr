# Supabase Terraform — Runbook

Bootstraps or recovers the Supabase Terraform stack in `infra/supabase`.

## Prerequisites

- [Terraform CLI installed locally](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [Supabase personal access token (PAT)](https://supabase.com/dashboard/account/tokens)
- Supabase organization id (`org_...`) where the project should be managed
- Access to [HCP Terraform](https://app.terraform.io/login) org `sabs-apps` (state is stored there)
- The following HCP Terraform workspaces already exist (from [infra/hcp-terraform](/infra/hcp-terraform/)):
  - `sabr-supabase-staging`
  - `sabr-supabase-production`

## Steps

### 1. Create a Supabase access token

In Supabase dashboard:

1. Click **Profile picture -> Account preferences -> Access Tokens**
2. Generate a token and copy it

Export it before running Terraform:

```bash
export SUPABASE_ACCESS_TOKEN="<token>"
```

### 2. Set required Terraform variables

Set the required variables:

```bash
export TF_VAR_organization_id="<supabase-org-id>"
export TF_VAR_project_name="<project-name>"
```

Use:

- staging workspace: `TF_VAR_project_name="sabr-staging"`
- production workspace: `TF_VAR_project_name="sabr-production"`

`project_region` is optional and defaults to `eu-west-2`. Override only if needed:

```bash
export TF_VAR_project_region="eu-west-2"
```

### 3. Initialize and apply

```bash
cd infra/supabase
terraform init
terraform workspace select sabr-supabase-staging
# or: terraform workspace select sabr-supabase-production
terraform plan
terraform apply
```

## Notes

- Outputs (`project_id`, `database_password`) are consumed by the [infra/github](/infra/github/) stack via `tfe_outputs`.
- If you see `workspace ... not found`, verify you selected `sabr-supabase-staging` or `sabr-supabase-production` and that [infra/hcp-terraform](/infra/hcp-terraform/) has already created those workspaces.

# Supabase Terraform — Runbook

Bootstraps or recovers the Supabase Terraform stack in `infra/supabase`.

## Prerequisites

- [Terraform CLI installed locally](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [Supabase personal access token (PAT)](https://supabase.com/dashboard/account/tokens)
- Supabase organization id where the project should be managed
- Access to [HCP Terraform](https://app.terraform.io/login) org `sabs-apps` (state is stored there)

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
- production workspace: `TF_VAR_project_name="sabr-prod"`

`project_region` is optional and defaults to `us-west-2`. Override only if needed:

```bash
export TF_VAR_project_region="us-west-2"
```

### 3. Initialize and apply

```bash
cd infra/supabase
terraform init
terraform plan
terraform apply
```

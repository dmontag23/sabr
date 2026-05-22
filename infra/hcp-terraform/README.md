# HashiCorp Cloud Platform (HCP) Terraform

Manages the Terraform Cloud (HCP Terraform) workspaces: the `sabs-apps` organization resources, the `sabr` project, and all workspaces used by that project.

## What this stack manages

- HCP Terraform organization (`sabs-apps`)
- Bootstrap workspace (`bootstrap`) where this stack stores state
- The `sabr` project
- The `sabr-github` workspace for [/infra/github](/infra/github/)
- The `sabr-resend` workspace for [/infra/resend](/infra/resend/)
- The `sabr-supabase-staging` and `sabr-supabase-production` workspaces for [/infra/supabase](/infra/supabase/)
- Shared variable set for Supabase workspaces
- Cross-workspace run triggers (Resend -> Supabase -> GitHub)

## File structure

- `bootstrap.tf`: organization + bootstrap workspace
- `locals.tf`: constants for necessary `sabr` environments and the `sabr` repo
- `organization_tokens.tf`: org token for `sabs-apps`
- `outputs.tf`: canonical environment names and Supabase workspace names
- `projects.tf`: project definitions
- `run_triggers.tf`: dependencies that trigger runs in other workspaces
- `tfe_variable_sets.tf`: workspace variables and shared Supabase variable set
- `variables.tf`: inputs to this stack
- `workspaces.tf`: workspace definitions

## Execution model

This stack intentionally uses **local execution mode** to manage the `bootstrap` workspace. You should plan & apply by running `terraform plan`/`terraform apply` locally. The state will remain in HCP Terraform (in the `bootstrap` workspace).

This is because workspace VCS connections rely on auth-ing to GitHub App via a user token, which is brittle to store, so local execution (which already needs a user) avoids having to store such a token in HCP Terraform.

## Day-to-day usage

```bash
cd infra/hcp-terraform
terraform init
terraform plan
terraform apply
```

## Apply order

When changes span multiple stacks, the stacks should be applied in this order:

1. `infra/hcp-terraform`
2. `infra/resend`
3. `infra/supabase`
4. `infra/github`

## Token rotation

To rotate user-supplied secret inputs, create or update `secrets.auto.tfvars` in [/infra/hcp-terraform](/infra/hcp-terraform/), then increment `value_wo_version` on the relevant write-only variables before applying.

User-supplied secret inputs in `secrets.auto.tfvars`:

- `github_token`
- `resend_api_key`
- `supabase_access_token`

There are some secret values not provided in `secrets.auto.tfvars`, but that are generated instead:

- `tfe_variable.github_tfe_token` (from `tfe_organization_token.sabs_apps.token`)
- `tfe_variable.supabase_tfe_token` (from `tfe_organization_token.sabs_apps.token`)

Other non-secret but required inputs are also read from `secrets.auto.tfvars`:

- `production_required_reviewer_username`
- `supabase_organization_id`

## First-time setup or disaster recovery

See [RUNBOOK.md](./RUNBOOK.md).

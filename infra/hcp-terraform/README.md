# HashiCorp Cloud Platform (HCP) Terraform

Manages the Terraform Cloud (HCP Terraform) workspaces: the `sabs-apps` organization resources, the `sabr` project, and all workspaces used by that project.

## What this stack manages

- HCP Terraform organization (`sabs-apps`)
- Bootstrap workspace (`bootstrap`) where this stack stores state
- The `sabr` project
- The `sabr-github` workspace for [/infra/github](/infra/github/)
- The `sabr-supabase-staging` and `sabr-supabase-production` workspaces for [/infra/supabase](/infra/supabase/)
- Shared variable set for Supabase workspaces
- Cross-workspace run triggers (Supabase -> GitHub)

## File structure

- `bootstrap.tf`: organization + bootstrap workspace
- `locals.tf`: constants for necessary `sabr` environments and the `sabr` repo
- `organization_tokens.tf`: org token for `sabs-apps`
- `outputs.tf`: canonical environment names and Supabase workspace names
- `projects.tf`: project definitions
- `run_triggers.tf`: Supabase to GitHub run triggers
- `tfe_variable_sets.tf`: workspace variables and shared Supabase variable set
- `variables.tf`: inputs to this stack
- `workspaces.tf`: GitHub and Supabase workspace definitions

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
2. `infra/supabase`
3. `infra/github`

## Token rotation

To rotate any secret tokens, create or update `secrets.auto.tfvars` in [/infra/hcp-terraform](/infra/hcp-terraform/), then increment `value_wo_version` on the relevant variables before applying. The secret variables are:

- `tfe_variable.github_token`
- `tfe_variable.tfe_token`
- `tfe_variable.supabase_access_token_terraform`
- `tfe_variable.supabase_access_token_env`

## First-time setup or disaster recovery

See [RUNBOOK.md](./RUNBOOK.md).

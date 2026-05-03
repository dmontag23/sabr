# Hashicorp Cloud Platform (HCP) Terraform

Manages HCP Terraform itself: the org, projects, workspaces, etc.

## What this module manages

- The HCP Terraform organization
- The `bootstrap` workspace (this code's own state lives here)
- The `sabr` project for the `sabr` app.
- The `sabr-github` workspace for [GitHub infrastructure](/infra/github/)

## Execution model

This stack runs in **local execution mode**: plan and apply happen on your laptop, state is stored in HCP Terraform. There is no PR-driven plan or merge-driven apply for this repo. Changes go through PR review, and someone runs `terraform apply` after merge.

This is intentional; remote execution requires a user token to manage GitHub App VCS connections. Setting a user token (e.g. as a variable in the `bootstrap` workspace) would break remote execution if said token is no longer able to be used.

Sensitive workspace variables for downstream workspaces can be managed here using `tfe_variable` with write-only values.

## Day-to-day usage

```bash
cd infra/hcp-terraform

terraform init
terraform plan
terraform apply
```

When rotating the GitHub token, update `secrets.auto.tfvars` and increment `value_wo_version` in [sabr.tf](./sabr.tf) before running `terraform apply` (see the [runbook](./RUNBOOK.md) for more information).

## First-time setup or disaster recovery

See the [runbook](./RUNBOOK.md).

# TODO

The configuration here is for all of sabs-apps, not just sabr. It should live in a separate repo.

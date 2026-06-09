# Resend

Manages Resend resources for the `sabr` app.

## State and execution

- Terraform state is stored in the [HCP Terraform](https://app.terraform.io/) workspace `sabr-resend` in the `sabs-apps` org.
- This workspace is maintained in [/infra/hcp-terraform/workspaces.tf](/infra/hcp-terraform/workspaces.tf).

## What this stack manages

- Resend domain and the API keys used by the rest of the project (see [main.tf](./main.tf))
- [Outputs](./outputs.tf) consumed by [infra/supabase](/infra/supabase/) (SMTP sending) and [infra/github](/infra/github/) (e2e testing API key)

## Authentication

- The Resend provider uses a workspace environment variable `RESEND_API_KEY` to authenticate. This env variable is managed by [the HCP Terraform stack](/infra/hcp-terraform/tfe_variable_sets.tf).

## Dependencies

[infra/hcp-terraform](/infra/hcp-terraform/) must have applied successfully so the `sabr-resend` workspace and `RESEND_API_KEY` variable exist.

[infra/supabase](/infra/supabase/) and [infra/github](/infra/github/) read this stack's [outputs](./outputs.tf) via `tfe_outputs`.

## Usage

```bash
cd infra/resend
terraform init
terraform plan
terraform apply
```

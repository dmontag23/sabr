# Resend — Runbook

Bootstraps or recovers the Resend, used as the SMTP mail provider for sabr.

State lives in the [HCP Terraform](https://app.terraform.io/login) **sabr-resend** workspace under the **sabs-apps** org. This workspace is created by the [HCP Terraform stack](/infra/hcp-terraform/workspaces.tf).

## Prerequisites

- [Terraform CLI installed locally](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- Access to the [HCP Terraform](https://app.terraform.io/login) org `sabs-apps`
- The `sabr-resend` workspace exists in the `sabs-apps` org
- The `RESEND_API_KEY` is set as an environment variable in the `sabr-resend` workspace

If workspace or variable setup is broken, setup the `RESEND_API_KEY` by following the [HCP Terraform runbook](/infra/hcp-terraform/RUNBOOK.md) first.

## Disaster Recovery

### Situation 1: HCP workspace exists, output missing/invalid

In this situation, it is only necessary to re-run `terraform apply` on the [infra/resend](/infra/resend/) stack.

### Situation 2: HCP workspace lost

In this situation, you need to rebuild the dependencies in order.

1. Recreate HCP workspaces/variables by following the [HCP Terraform runbook](/infra/hcp-terraform/RUNBOOK.md).
2. Re-run `terraform apply` in [this stack](/infra/resend/) to recreate the API keys (Supabase SMTP integration and e2e tests).
3. Re-run `terraform apply` in the consuming stacks so they pick up the new outputs: [infra/supabase](/infra/supabase/) (SMTP) and [infra/github](/infra/github/) (e2e test API key).

## Verification checklist

- `terraform plan` in `infra/resend` shows no changes.
- The stack's [outputs](./outputs.tf) exist in the `sabr-resend` workspace.
- A subsequent apply in each consuming stack ([infra/supabase](/infra/supabase/) and [infra/github](/infra/github/)) succeeds.

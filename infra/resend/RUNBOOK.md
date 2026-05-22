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
2. Re-run `terraform apply` in [this stack](/infra/resend/) to create the API key for the supabase SMTP integration.
3. Re-run `terraform apply` in [infra/supabase](/infra/supabase/) so SMTP is setup via Resend.

## Verification checklist

- `terraform plan` in `infra/resend` shows no changes.
- The `supabase_smtp_api_key` output exists in the `sabr-resend` workspace.
- A subsequent apply in [infra/supabase](/infra/supabase/) succeeds.

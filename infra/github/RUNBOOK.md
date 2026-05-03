# GitHub — Runbook

This stack manages GitHub resources for the sabr repo.

State lives in the [HCP Terraform](https://app.terraform.io/login) workspace **sabr-github** (org **sabs-apps**).
The workspace is created by the [HCP Terraform stack](/infra/hcp-terraform/sabr.tf).

## Prerequisites

- [HCP Terraform](https://app.terraform.io/login) org **sabs-apps** and project **sabr** exist.
- GitHub repository `sabr` exists.
- GitHub App is installed on HCP Terraform (see the [runbook for HCP Terraform](/infra/hcp-terraform/RUNBOOK.md))
  - If App scope is **Only select repositories**, ensure `sabr` is selected.
- A GitHub personal access token. Local terraform imports needs the `GITHUB_TOKEN` environment variable available in your shell because sensitive HCP workspace variables are not injected into local Terraform runs.

If workspace, VCS connection, or `GITHUB_TOKEN` is broken, stop and run the [HCP Terraform runbook](/infra/hcp-terraform/RUNBOOK.md).

## Bootstrap

Import existing repository into state

```bash
cd infra/github
terraform init
export GITHUB_TOKEN="<your_github_token>"
terraform import github_repository.sabr sabr
terraform apply
unset GITHUB_TOKEN
```

---

## Disaster Recovery (DR)

### Situation 1: GitHub repo lost, HCP workspace still exists

Goal: recreate repo first, then re-link Terraform state.

1. Recreate the empty `sabr` repo on GitHub.
2. Push repository contents back to `main`.
3. Verify GitHub App access:
   - If App scope is **Only select repositories**, re-add `sabr`.
4. Follow the steps in the [Bootstrap](#bootstrap) section above.

### Situation 2: Both HCP state/workspace and GitHub repo lost (full disaster)

Goal: rebuild in dependency order.

1. Recreate the `sabr` GitHub repo.
2. Push repo contents to `main`.
3. Verify or reconfigure GitHub App access to `sabr`.
4. Recreate HCP side by following the [HCP Terraform runbook](/infra/hcp-terraform/RUNBOOK.md).
5. Reimport GitHub resource:
   ```bash
   cd infra/github
   terraform init
   export GITHUB_TOKEN="<your_github_token>"
   terraform import github_repository.sabr sabr
   terraform apply
   unset GITHUB_TOKEN
   ```

## Verification checklist after any DR

- `terraform plan` does not contain any changes.
- The `sabr` repository settings match the terraform.

resource "tfe_organization" "sabs_apps" {
  name  = "sabs-apps"
  email = "dmontag23@gmail.com"
}

resource "tfe_workspace" "bootstrap" {
  name         = "bootstrap"
  description  = "Manages the sabs-apps organization and its workspaces."
  organization = tfe_organization.sabs_apps.name

  lifecycle {
    prevent_destroy = true
  }
}

resource "tfe_workspace_settings" "bootstrap" {
  workspace_id = tfe_workspace.bootstrap.id
  # hcp-terraform infra changes should be executed on a local machine, not remotely on the HCP Terraform cloud.
  # Plans for hcp-terraform infra changes will not appear on PRs, and applies will not run automatically on main.
  # All plans and applies must be made manually via the Terraform CLI on a local machine.
  # This is because the GitHub App requires using a user auth token to connect workspaces to GitHub.
  # The remote executor would need to use such a token. However, this is problematic
  # because that user's account could be lost, that user could leave the project, etc, which would break the remote executor.
  # Local users will already have a user auth token from running `terraform login` locally, so this is the
  # flow with the least amount of friction. This also limits the blast radius of applying changes to HCP Terraform,
  # which controls all other infra state.
  execution_mode = "local"
}

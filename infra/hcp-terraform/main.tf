resource "tfe_organization" "main" {
  name  = var.organization_name
  email = var.organization_email
}

resource "tfe_workspace" "bootstrap" {
  name         = "bootstrap"
  description  = "Manages the organization and other workspaces."
  organization = tfe_organization.main.name
}

resource "tfe_variable" "tfe_token" {
  workspace_id = tfe_workspace.bootstrap.id
  key          = "TFE_TOKEN"
  value        = var.tfe_token
  category     = "env"
  sensitive    = true
  description  = "User token used by the tfe provider."
}

resource "tfe_organization" "main" {
  name  = "sabs-apps"
  email = "dmontag23@gmail.com"
}

resource "tfe_workspace" "bootstrap" {
  name         = "bootstrap"
  description  = "Manages the organization and other workspaces."
  organization = tfe_organization.main.name
}

// TODO: (Low priority) Rotate this token on a fixed schedule
resource "tfe_organization_token" "bootstrap_org_token" {
  organization = tfe_organization.main.name
}

resource "tfe_variable" "tfe_token" {
  workspace_id = tfe_workspace.bootstrap.id
  key          = "TFE_TOKEN"
  value        = tfe_organization_token.bootstrap_org_token.token
  category     = "env"
  sensitive    = true
  description  = "Org token used by the tfe provider."
}

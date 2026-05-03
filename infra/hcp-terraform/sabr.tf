resource "tfe_project" "sabr" {
  organization = tfe_organization.sabs_apps.name
  name         = "sabr"
}

resource "tfe_workspace" "github" {
  name              = "sabr-github"
  description       = "GitHub repository for the sabr app."
  organization      = tfe_organization.sabs_apps.name
  project_id        = tfe_project.sabr.id
  auto_apply        = false
  working_directory = "infra/github"
  trigger_patterns  = ["infra/github/**/*"]

  vcs_repo {
    identifier                 = "dmontag23/sabr"
    github_app_installation_id = data.tfe_github_app_installation.gha_installation.id
  }
}

variable "github_token" {
  type      = string
  ephemeral = true
  sensitive = true
}

resource "tfe_variable" "github_token" {
  key          = "github_token"
  sensitive    = true
  category     = "terraform"
  workspace_id = tfe_workspace.github.id
  description  = "GitHub token with permission to manage the sabr repository."

  value_wo         = var.github_token
  value_wo_version = 1
}

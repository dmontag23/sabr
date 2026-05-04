resource "tfe_project" "sabr" {
  organization = tfe_organization.sabs_apps.name
  name         = "sabr"
}

resource "tfe_workspace" "github" {
  name              = "sabr-github"
  description       = "GitHub repository for the sabr app."
  organization      = tfe_organization.sabs_apps.name
  project_id        = tfe_project.sabr.id
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
  key          = "GITHUB_TOKEN"
  sensitive    = true
  category     = "env"
  workspace_id = tfe_workspace.github.id
  description  = "GitHub token with permission to manage the sabr repository."

  value_wo         = var.github_token
  value_wo_version = 1
}

resource "tfe_workspace" "supabase_prod" {
  name              = "sabr-supabase-prod"
  description       = "Production Supabase project for the sabr app."
  organization      = tfe_organization.sabs_apps.name
  project_id        = tfe_project.sabr.id
  working_directory = "infra/supabase"
  trigger_patterns  = ["infra/supabase/**/*"]
  tag_names         = ["stack:sabr-supabase"]
  vcs_repo {
    identifier                 = "dmontag23/sabr"
    github_app_installation_id = data.tfe_github_app_installation.gha_installation.id
  }
}

variable "supabase_organization_id" {
  type = string
}


resource "tfe_variable_set" "supabase_shared_variables" {
  name          = "sabr-supabase-shared-variables"
  description   = "Shared variables for the sabr Supabase workspaces"
  organization  = tfe_organization.sabs_apps.name
  workspace_ids = [tfe_workspace.supabase_prod.id]
}

resource "tfe_variable" "supabase_organization_id" {
  key             = "organization_id"
  category        = "terraform"
  variable_set_id = tfe_variable_set.supabase_shared_variables.id
  description     = "Supabase organization slug."
  value           = var.supabase_organization_id
}

variable "supabase_prod_access_token" {
  type      = string
  ephemeral = true
  sensitive = true
}

resource "tfe_variable" "supabase_prod_access_token" {
  key          = "SUPABASE_ACCESS_TOKEN"
  sensitive    = true
  category     = "env"
  workspace_id = tfe_workspace.supabase_prod.id
  description  = "Production Supabase personal access token."

  value_wo         = var.supabase_prod_access_token
  value_wo_version = 1
}

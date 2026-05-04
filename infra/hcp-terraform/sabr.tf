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

resource "tfe_workspace" "supabase_staging" {
  name              = "sabr-supabase-staging"
  description       = "Staging Supabase project for the sabr app."
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

resource "tfe_variable" "supabase_staging_project_name" {
  key          = "project_name"
  category     = "terraform"
  workspace_id = tfe_workspace.supabase_staging.id
  description  = "Supabase project name for staging environment."
  value        = "sabr-staging"
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

resource "tfe_variable" "supabase_prod_project_name" {
  key          = "project_name"
  category     = "terraform"
  workspace_id = tfe_workspace.supabase_prod.id
  description  = "Supabase project name for production environment."
  value        = "sabr-prod"
}

variable "supabase_organization_id" {
  type = string
}

variable "supabase_access_token" {
  type      = string
  ephemeral = true
  sensitive = true
}

variable "production_required_reviewer_username" {
  type = string
}

resource "tfe_variable_set" "supabase_shared_variables" {
  name          = "sabr-supabase-shared-variables"
  description   = "Shared variables for the sabr Supabase workspaces."
  organization  = tfe_organization.sabs_apps.name
  workspace_ids = [tfe_workspace.supabase_staging.id, tfe_workspace.supabase_prod.id]
}

resource "tfe_variable" "supabase_organization_id" {
  key             = "organization_id"
  category        = "terraform"
  variable_set_id = tfe_variable_set.supabase_shared_variables.id
  description     = "Supabase organization slug."

  value = var.supabase_organization_id
}

resource "tfe_variable" "supabase_access_token_variable_set" {
  key             = "SUPABASE_ACCESS_TOKEN"
  category        = "env"
  sensitive       = true
  variable_set_id = tfe_variable_set.supabase_shared_variables.id
  description     = "Supabase access token."

  value_wo         = var.supabase_access_token
  value_wo_version = 1
}

resource "tfe_variable" "supabase_access_token_github" {
  key          = "supabase_access_token"
  category     = "terraform"
  sensitive    = true
  workspace_id = tfe_workspace.github.id
  description  = "Supabase access token."

  value_wo         = var.supabase_access_token
  value_wo_version = 1
}

resource "tfe_variable" "production_required_reviewer_username" {
  key          = "production_required_reviewer_username"
  category     = "terraform"
  workspace_id = tfe_workspace.github.id
  description  = "Required production deployment approver username."

  value = var.production_required_reviewer_username
}

resource "tfe_workspace_settings" "supabase_staging_remote_state_sharing" {
  workspace_id              = tfe_workspace.supabase_staging.id
  remote_state_consumer_ids = [tfe_workspace.github.id]
}

resource "tfe_workspace_settings" "supabase_prod_remote_state_sharing" {
  workspace_id              = tfe_workspace.supabase_prod.id
  remote_state_consumer_ids = [tfe_workspace.github.id]
}

resource "tfe_run_trigger" "supabase_staging_triggers_github" {
  workspace_id  = tfe_workspace.github.id
  sourceable_id = tfe_workspace.supabase_staging.id
}

resource "tfe_run_trigger" "supabase_prod_triggers_github" {
  workspace_id  = tfe_workspace.github.id
  sourceable_id = tfe_workspace.supabase_prod.id
}

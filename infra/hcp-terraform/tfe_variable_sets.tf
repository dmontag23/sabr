# Variables for the GitHub workspace
resource "tfe_variable" "github_token" {
  key          = "GITHUB_TOKEN"
  sensitive    = true
  category     = "env"
  workspace_id = tfe_workspace.github.id
  description  = "GitHub token with permission to manage the sabr repository."

  value_wo         = var.github_token
  value_wo_version = 1
}

resource "tfe_variable" "github_tfe_token" {
  key          = "TFE_TOKEN"
  sensitive    = true
  category     = "env"
  workspace_id = tfe_workspace.github.id
  description  = "HCP Terraform organization token."

  value_wo         = tfe_organization_token.sabs_apps.token
  value_wo_version = 1
}

resource "tfe_variable" "production_required_reviewer_username" {
  key          = "production_required_reviewer_username"
  category     = "terraform"
  workspace_id = tfe_workspace.github.id
  description  = "GitHub username required to approve production deployments."

  value = var.production_required_reviewer_username
}

resource "tfe_variable" "supabase_access_token_terraform" {
  key          = "supabase_access_token"
  category     = "terraform"
  sensitive    = true
  workspace_id = tfe_workspace.github.id
  description  = "Supabase access token."

  value_wo         = var.supabase_access_token
  value_wo_version = 2
}

# Variables for the Resend workspace
resource "tfe_variable" "resend_api_key" {
  key          = "RESEND_API_KEY"
  sensitive    = true
  category     = "env"
  workspace_id = tfe_workspace.resend.id
  description  = "Resend API key with full access permissions."

  value_wo         = var.resend_api_key
  value_wo_version = 1
}

# Variables for the Supabase workspaces
resource "tfe_variable_set" "supabase_shared_variables" {
  name          = "sabr-supabase-shared-variables"
  description   = "Shared variables for the sabr Supabase workspaces."
  organization  = tfe_organization.sabs_apps.name
  workspace_ids = [for workspace in tfe_workspace.supabase : workspace.id]
}

resource "tfe_variable" "supabase_access_token_env" {
  key             = "SUPABASE_ACCESS_TOKEN"
  category        = "env"
  sensitive       = true
  variable_set_id = tfe_variable_set.supabase_shared_variables.id
  description     = "Supabase access token."

  value_wo         = var.supabase_access_token
  value_wo_version = 2
}

resource "tfe_variable" "supabase_tfe_token" {
  key             = "TFE_TOKEN"
  sensitive       = true
  category        = "env"
  variable_set_id = tfe_variable_set.supabase_shared_variables.id
  description     = "HCP Terraform organization token."

  value_wo         = tfe_organization_token.sabs_apps.token
  value_wo_version = 1
}

resource "tfe_variable" "supabase_organization_id" {
  key             = "organization_id"
  category        = "terraform"
  variable_set_id = tfe_variable_set.supabase_shared_variables.id
  description     = "Supabase organization id."

  value = var.supabase_organization_id
}

resource "tfe_variable" "supabase_project_name" {
  for_each = local.environments

  key          = "project_name"
  category     = "terraform"
  workspace_id = tfe_workspace.supabase[each.key].id
  description  = "Supabase project name."
  value        = "sabr-${each.key}"
}

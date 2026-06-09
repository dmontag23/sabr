resource "github_actions_secret" "supabase_access_token" {
  repository  = github_repository.sabr.name
  secret_name = "SUPABASE_ACCESS_TOKEN"
  value       = var.supabase_access_token
}

resource "github_actions_environment_secret" "supabase_db_password" {
  for_each = local.deployment_environments

  repository  = github_repository.sabr.name
  environment = github_repository_environment.environment[each.key].environment
  secret_name = "SUPABASE_DB_PASSWORD"
  value       = data.tfe_outputs.supabase[each.key].values["database_password"]
}

resource "github_actions_environment_variable" "supabase_project_id" {
  for_each = local.deployment_environments

  repository    = github_repository.sabr.name
  environment   = github_repository_environment.environment[each.key].environment
  variable_name = "SUPABASE_PROJECT_ID"
  value         = data.tfe_outputs.supabase[each.key].nonsensitive_values["project_id"]
}

resource "github_actions_environment_variable" "supabase_publishable_key" {
  for_each = local.deployment_environments

  repository    = github_repository.sabr.name
  environment   = github_repository_environment.environment[each.key].environment
  variable_name = "EXPO_PUBLIC_SUPABASE_PUBLISHABLE_KEY"
  value         = data.tfe_outputs.supabase[each.key].values["publishable_key"]
}

resource "github_actions_environment_variable" "supabase_url" {
  for_each = local.deployment_environments

  repository    = github_repository.sabr.name
  environment   = github_repository_environment.environment[each.key].environment
  variable_name = "EXPO_PUBLIC_SUPABASE_URL"
  value         = data.tfe_outputs.supabase[each.key].nonsensitive_values["url"]
}

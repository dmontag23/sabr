output "environment_names" {
  description = "Canonical environment names."
  value       = local.environments
}

output "sabr_supabase_environment_names" {
  description = "Supabase environment names for the sabr app keyed by canonical environment name."
  value       = { for env, ws in tfe_workspace.supabase : env => ws.name }
}

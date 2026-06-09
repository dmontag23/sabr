

output "database_password" {
  description = "Supabase Postgres password."
  value       = random_password.db_password.result
  sensitive   = true
}

output "project_id" {
  description = "Supabase project ID."
  value       = supabase_project.sabr.id
}

output "publishable_key" {
  description = "Supabase publishable API key."
  value       = data.supabase_apikeys.sabr.publishable_key
  sensitive   = true
}

output "url" {
  description = "Supabase project API URL."
  value       = "https://${supabase_project.sabr.id}.supabase.co"
}

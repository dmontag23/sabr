output "project_id" {
  description = "Supabase project ID."
  value       = supabase_project.sabr.id
}

output "database_password" {
  description = "Supabase Postgres password."
  value       = random_password.db_password.result
  sensitive   = true
}

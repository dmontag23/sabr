output "e2e_tests_api_key" {
  description = "Resend API key used by e2e tests to read emails."
  value       = resend_api_key.e2e_tests_api_key.token
  sensitive   = true
}

output "supabase_smtp_api_key" {
  description = "Resend API key for Supabase SMTP integration."
  value       = resend_api_key.supabase_smtp_api_key.token
  sensitive   = true
}

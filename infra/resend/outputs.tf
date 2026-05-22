output "supabase_smtp_api_key" {
  description = "Resend API key for Supabase SMTP integration."
  value       = resend_api_key.supabase_smtp_api_key.token
  sensitive   = true
}

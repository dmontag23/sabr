resource "resend_api_key" "supabase_smtp_api_key" {
  name       = "sabr-supabase-smtp-integration"
  permission = "sending_access"
}

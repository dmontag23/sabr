resource "resend_domain" "sabr" {
  name   = "notifications.unlikely.ai"
  region = "eu-west-1"
  tls    = "enforced"
}

resource "resend_domain_verification" "sabr" {
  domain_id = resend_domain.sabr.id
}

resource "resend_api_key" "supabase_smtp_api_key" {
  name       = "sabr-supabase-smtp-integration"
  permission = "sending_access"
  domain_id  = resend_domain.sabr.id
}

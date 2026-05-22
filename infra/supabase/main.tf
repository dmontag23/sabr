resource "time_rotating" "db_password" {
  rotation_days = 30
}

resource "random_password" "db_password" {
  length = 99

  keepers = {
    rotation = time_rotating.db_password.id
  }
}

resource "supabase_project" "sabr" {
  organization_id   = var.organization_id
  name              = var.project_name
  database_password = random_password.db_password.result
  region            = var.project_region
}

resource "supabase_settings" "sabr" {
  project_ref = supabase_project.sabr.id

  auth = jsonencode({
    external_email_enabled = true

    mailer_subjects_magic_link          = "Log into Sabr"
    mailer_templates_magic_link_content = file("${path.module}/../../supabase/templates/magic_link.html")

    smtp_host = "smtp.resend.com"
    smtp_pass = data.tfe_outputs.resend.values["supabase_smtp_api_key"]
    smtp_port = 465
    smtp_user = "resend"
  })
}

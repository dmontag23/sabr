data "supabase_apikeys" "sabr" {
  project_ref = supabase_project.sabr.id
}

data "tfe_outputs" "resend" {
  organization = "sabs-apps"
  workspace    = "sabr-resend"
}

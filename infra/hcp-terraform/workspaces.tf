data "tfe_github_app_installation" "gha_installation" {
  name = "dmontag23"
}

resource "tfe_workspace" "github" {
  name              = "sabr-github"
  description       = "GitHub repository for the sabr app."
  organization      = tfe_organization.sabs_apps.name
  project_id        = tfe_project.sabr.id
  working_directory = "infra/github"
  trigger_patterns  = ["infra/github/**/*"]

  vcs_repo {
    identifier                 = local.repository_identifier
    github_app_installation_id = data.tfe_github_app_installation.gha_installation.id
  }
}

resource "tfe_workspace" "supabase" {
  for_each = local.environments

  name              = "sabr-supabase-${each.key}"
  description       = "${title(each.key)} Supabase project for the sabr app."
  organization      = tfe_organization.sabs_apps.name
  project_id        = tfe_project.sabr.id
  working_directory = "infra/supabase"
  trigger_patterns  = ["infra/supabase/**/*"]
  tag_names         = ["stack:sabr-supabase"]

  vcs_repo {
    identifier                 = local.repository_identifier
    github_app_installation_id = data.tfe_github_app_installation.gha_installation.id
  }
}

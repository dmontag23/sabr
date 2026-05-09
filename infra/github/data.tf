data "tfe_outputs" "hcp_bootstrap" {
  organization = local.organization_name
  workspace    = "bootstrap"
}

data "tfe_outputs" "supabase" {
  for_each     = local.deployment_environments
  organization = local.organization_name
  workspace    = data.tfe_outputs.hcp_bootstrap.nonsensitive_values["sabr_supabase_environment_names"][each.key]
}

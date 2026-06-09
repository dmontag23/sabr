resource "tfe_run_trigger" "resend_triggers_github" {
  sourceable_id = tfe_workspace.resend.id
  workspace_id  = tfe_workspace.github.id
}

resource "tfe_run_trigger" "resend_triggers_supabase" {
  for_each = local.environments

  sourceable_id = tfe_workspace.resend.id
  workspace_id  = tfe_workspace.supabase[each.key].id
}

resource "tfe_run_trigger" "supabase_triggers_github" {
  for_each = local.environments

  sourceable_id = tfe_workspace.supabase[each.key].id
  workspace_id  = tfe_workspace.github.id
}

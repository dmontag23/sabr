resource "tfe_run_trigger" "supabase_triggers_github" {
  for_each = local.environments

  workspace_id  = tfe_workspace.github.id
  sourceable_id = tfe_workspace.supabase[each.key].id
}

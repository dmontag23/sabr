moved {
  from = data.tfe_outputs.supabase_staging
  to   = data.tfe_outputs.supabase["staging"]
}

moved {
  from = data.tfe_outputs.supabase_production
  to   = data.tfe_outputs.supabase["production"]
}

moved {
  from = github_repository_environment.staging
  to   = github_repository_environment.environment["staging"]
}

moved {
  from = github_repository_environment.production
  to   = github_repository_environment.environment["production"]
}

moved {
  from = github_repository_environment_deployment_policy.staging_develop
  to   = github_repository_environment_deployment_policy.environment["staging"]
}

moved {
  from = github_repository_environment_deployment_policy.production_main
  to   = github_repository_environment_deployment_policy.environment["production"]
}

moved {
  from = github_actions_environment_secret.staging_project_id
  to   = github_actions_environment_secret.project_id["staging"]
}

moved {
  from = github_actions_environment_secret.production_project_id
  to   = github_actions_environment_secret.project_id["production"]
}

moved {
  from = github_actions_environment_secret.staging_db_password
  to   = github_actions_environment_secret.db_password["staging"]
}

moved {
  from = github_actions_environment_secret.production_db_password
  to   = github_actions_environment_secret.db_password["production"]
}

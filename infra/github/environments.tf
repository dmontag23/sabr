data "github_user" "production_reviewer" {
  username = var.production_required_reviewer_username
}

resource "github_repository_environment" "environment" {
  for_each = local.deployment_environments

  repository        = github_repository.sabr.name
  environment       = each.key
  can_admins_bypass = true

  dynamic "reviewers" {
    for_each = each.value.require_reviewer ? [1] : []
    content {
      users = [data.github_user.production_reviewer.id]
    }
  }

  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }
}

resource "github_repository_environment_deployment_policy" "environment" {
  for_each = merge([
    for env_key, env in local.deployment_environments : {
      for pattern in env.branch_patterns :
      "${env_key}/${pattern}" => {
        environment    = env_key
        branch_pattern = pattern
      }
    }
  ]...)

  repository     = github_repository.sabr.name
  environment    = github_repository_environment.environment[each.value.environment].environment
  branch_pattern = each.value.branch_pattern
}

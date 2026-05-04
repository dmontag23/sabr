resource "github_repository" "sabr" {
  name                   = "sabr"
  description            = "A finance app for the people you share life with."
  delete_branch_on_merge = true
}

resource "github_repository_ruleset" "sabr_default_branch_protection" {
  name        = "default-branch-protection"
  repository  = github_repository.sabr.name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  bypass_actors {
    actor_type  = "RepositoryRole"
    actor_id    = 5
    bypass_mode = "always"
  }

  rules {
    required_linear_history = true

    pull_request {
      required_approving_review_count   = 1
      dismiss_stale_reviews_on_push     = true
      required_review_thread_resolution = true
      require_last_push_approval        = true
      require_code_owner_review         = true
    }

    required_status_checks {
      strict_required_status_checks_policy = true

      required_check {
        context = "Run pre-commit"
      }
    }
  }
}

data "tfe_outputs" "supabase_staging" {
  organization = "sabs-apps"
  workspace    = "sabr-supabase-staging"
}

data "tfe_outputs" "supabase_production" {
  organization = "sabs-apps"
  workspace    = "sabr-supabase-prod"
}

data "github_user" "production_reviewer" {
  username = var.production_required_reviewer_username
}

resource "github_repository_environment" "staging" {
  repository  = github_repository.sabr.name
  environment = "staging"

  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }
}

resource "github_repository_environment_deployment_policy" "staging_develop" {
  repository     = github_repository.sabr.name
  environment    = github_repository_environment.staging.environment
  branch_pattern = "develop"
}

resource "github_repository_environment" "production" {
  repository        = github_repository.sabr.name
  environment       = "production"
  can_admins_bypass = true

  reviewers {
    users = [data.github_user.production_reviewer.id]
  }

  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }
}

resource "github_repository_environment_deployment_policy" "production_main" {
  repository     = github_repository.sabr.name
  environment    = github_repository_environment.production.environment
  branch_pattern = "main"
}

resource "github_actions_secret" "supabase_access_token" {
  repository  = github_repository.sabr.name
  secret_name = "SUPABASE_ACCESS_TOKEN"
  value       = var.supabase_access_token
}

resource "github_actions_environment_secret" "staging_project_id" {
  repository  = github_repository.sabr.name
  environment = github_repository_environment.staging.environment
  secret_name = "SUPABASE_PROJECT_ID"
  value       = data.tfe_outputs.supabase_staging.nonsensitive_values["project_id"]
}

resource "github_actions_environment_secret" "staging_db_password" {
  repository  = github_repository.sabr.name
  environment = github_repository_environment.staging.environment
  secret_name = "SUPABASE_DB_PASSWORD"
  value       = data.tfe_outputs.supabase_staging.values["database_password"]
}

resource "github_actions_environment_secret" "production_project_id" {
  repository  = github_repository.sabr.name
  environment = github_repository_environment.production.environment
  secret_name = "SUPABASE_PROJECT_ID"
  value       = data.tfe_outputs.supabase_production.nonsensitive_values["project_id"]
}

resource "github_actions_environment_secret" "production_db_password" {
  repository  = github_repository.sabr.name
  environment = github_repository_environment.production.environment
  secret_name = "SUPABASE_DB_PASSWORD"
  value       = data.tfe_outputs.supabase_production.values["database_password"]
}

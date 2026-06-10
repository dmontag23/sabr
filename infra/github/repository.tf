resource "github_repository" "sabr" {
  name                   = "sabr"
  description            = "A finance app for the people you share life with."
  delete_branch_on_merge = true
}

resource "github_repository_ruleset" "sabr_branch_protection" {
  for_each = {
    default = ["~DEFAULT_BRANCH"]
    develop = ["refs/heads/develop"]
  }

  name        = "${each.key}-branch-protection"
  repository  = github_repository.sabr.name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = each.value
      exclude = []
    }
  }

  bypass_actors {
    actor_type  = "RepositoryRole"
    actor_id    = 5 # admin
    bypass_mode = "always"
  }

  rules {
    deletion         = true
    non_fast_forward = true

    pull_request {
      required_approving_review_count   = 1
      dismiss_stale_reviews_on_push     = true
      required_review_thread_resolution = true
      require_last_push_approval        = true
      require_code_owner_review         = true
    }

    required_status_checks {
      strict_required_status_checks_policy = true

      dynamic "required_check" {
        # the names below much match GitHub Actions job names
        for_each = [
          "Run pre-commit",
          "Static checks and unit/integration tests 🧪",
          "Supabase type drift",
        ]

        content { context = required_check.value }
      }
    }
  }
}

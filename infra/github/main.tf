resource "github_repository" "sabr" {
  name                   = "sabr"
  description            = "A finance app for the people you share life with."
  delete_branch_on_merge = true
}

resource "github_repository_ruleset" "default_branch_protection" {
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
        context = "Pre-commit / Run pre-commit (pull_request)"
      }
    }
  }
}

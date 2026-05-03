terraform {
  cloud {
    organization = "sabs-apps"

    workspaces {
      project = "sabr"
      name    = "sabr-github"
    }
  }

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }

  required_version = ">= 1.15"
}

terraform {
  cloud {
    organization = "sabs-apps"

    workspaces {
      name = "sabr-github"
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

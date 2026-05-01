terraform {

  cloud {
    organization = "sabs-apps"

    workspaces {
      name = "bootstrap"
    }
  }
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.76"
    }
  }

  required_version = ">= 1.15"
}

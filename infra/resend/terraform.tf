terraform {
  cloud {
    organization = "sabs-apps"

    workspaces {
      project = "sabr"
      name    = "sabr-resend"
    }
  }

  required_providers {
    resend = {
      # TODO: This is a community provider. It should be replaced with the official provider when available.
      source  = "y0n0zawa/resend"
      version = "~> 1.0"
    }
  }

  required_version = ">= 1.15"
}

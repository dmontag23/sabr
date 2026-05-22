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
      source  = "y0n0zawa/resend"
      version = "~> 1.0"
    }
  }

  required_version = ">= 1.15"
}

terraform {

  cloud {
    organization = "sabs-apps"

    workspaces {
      project = "sabr"
      tags    = ["stack:sabr-supabase"]
    }
  }

  required_providers {
    supabase = {
      source  = "supabase/supabase"
      version = "~> 1.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }

    time = {
      source  = "hashicorp/time"
      version = "~> 0.13"
    }
  }

  required_version = ">= 1.15"
}

locals {
  environment_names = data.tfe_outputs.hcp_bootstrap.nonsensitive_values["environment_names"]

  github_deployment_environments = {

    staging = {
      branch_pattern   = "develop"
      require_reviewer = false
    }

    production = {
      branch_pattern   = "main"
      require_reviewer = true
    }
  }

  deployment_environments = {
    for env in local.environment_names :
    env => local.github_deployment_environments[env]
  }

  organization_name = "sabs-apps"
}

check "no_extra_github_environment_keys" {
  assert {
    condition = length(setsubtract(
      toset(keys(local.github_deployment_environments)),
      local.environment_names
    )) == 0
    error_message = "github_deployment_environments has keys not in canonical HCP Terraform environment list."
  }
}

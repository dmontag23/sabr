variable "organization_name" {
  type        = string
  description = "Name of the organization to create."
}

variable "organization_email" {
  type        = string
  description = "Admin email for the organization."
}

variable "tfe_token" {
  type        = string
  description = "Token to inject into the workspace so future runs can authenticate to the TFE API."
  sensitive   = true
}

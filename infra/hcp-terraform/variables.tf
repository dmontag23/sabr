variable "github_token" {
  description = "GitHub token with permission to manage the sabr repository."
  type        = string
  ephemeral   = true
  sensitive   = true
}

variable "production_required_reviewer_username" {
  description = "GitHub username required to approve production deployments."
  type        = string
}

variable "resend_api_key" {
  description = "Resend access token."
  type        = string
  ephemeral   = true
  sensitive   = true
}

variable "supabase_access_token" {
  description = "Supabase access token."
  type        = string
  ephemeral   = true
  sensitive   = true
}

variable "supabase_organization_id" {
  description = "Supabase organization id."
  type        = string
}

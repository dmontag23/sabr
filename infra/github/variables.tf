variable "production_required_reviewer_username" {
  description = "GitHub username required to approve production deployments."
  type        = string
}

variable "supabase_access_token" {
  description = "Supabase access token."
  type        = string
  sensitive   = true
}

variable "organization_id" {
  description = "Supabase organization id."
  type        = string
}

variable "project_name" {
  description = "Supabase project name."
  type        = string
}

variable "project_region" {
  description = "Supabase project region."
  type        = string
  default     = "eu-west-2"
}

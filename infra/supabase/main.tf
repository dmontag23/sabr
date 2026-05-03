resource "time_rotating" "db_password" {
  rotation_days = 30
}

resource "random_password" "db_password" {
  length = 99

  keepers = {
    rotation = time_rotating.db_password.id
  }
}

resource "supabase_project" "sabr" {
  organization_id   = var.organization_id
  name              = var.project_name
  database_password = random_password.db_password.result
  region            = var.project_region
}

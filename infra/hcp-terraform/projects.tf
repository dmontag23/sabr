resource "tfe_project" "sabr" {
  organization = tfe_organization.sabs_apps.name
  name         = "sabr"
}

resource "tfe_organization_token" "sabs_apps" {
  organization = tfe_organization.sabs_apps.name
}

resource "github_repository" "sabr" {
  name                   = "sabr"
  description            = "A finance app for the people you share life with."
  delete_branch_on_merge = true
}

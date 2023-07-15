resource "github_team" "infra" {
  name    = "infra"
  privacy = "closed"
}

resource "github_team" "sre" {
  description    = "Site Reliability Engineer"
  name           = "sre"
  parent_team_id = github_team.infra.id
  privacy        = "closed"
}

resource "github_team_members" "sre" {
  team_id = github_team.sre.id

  dynamic "members" {
    for_each = var.team_members.sre

    content {
      role     = members.value.role
      username = members.value.username
    }
  }
}

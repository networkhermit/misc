resource "github_branch_protection" "custom" {
  for_each = var.branch_protection

  pattern       = each.value.pattern
  repository_id = each.value.repo
}

resource "github_branch_protection" "default" {
  for_each = toset(data.github_repositories.repos_within_org.names)

  pattern       = var.default_branch
  repository_id = each.key
}

data "github_repositories" "repos_within_org" {
  query = "org:${var.GITHUB_OWNER}"
}

resource "github_team" "dev" {
  description = "Developer"
  name        = "dev"
  privacy     = "closed"
}

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

resource "github_team_members" "dev" {
  team_id = github_team.dev.id

  dynamic "members" {
    for_each = concat(var.team_members.dev, var.team_members.sre)

    content {
      role     = members.value.role
      username = members.value.username
    }
  }
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

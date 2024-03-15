resource "harbor_robot_account" "proxy_cache" {
  for_each = nonsensitive(var.proxy_cache_accounts)

  level  = "system"
  name   = each.key
  secret = each.value.secret

  dynamic "permissions" {
    for_each = [
      harbor_project.dockerhub.name,
      harbor_project.gcr.name,
      harbor_project.ghcr.name,
      harbor_project.k8s_registry.name,
      harbor_project.quay.name,
    ]

    content {
      access {
        action   = "pull"
        resource = "repository"
      }
      kind      = "project"
      namespace = permissions.value
    }
  }
}

resource "harbor_retention_policy" "proxy_cache" {
  for_each = {
    dockerhub    = harbor_project.dockerhub.id
    gcr          = harbor_project.gcr.id
    ghcr         = harbor_project.ghcr.id
    k8s_registry = harbor_project.k8s_registry.id
    quay         = harbor_project.quay.id
  }

  schedule = "0 0 */12 * * *"
  scope    = each.value

  rule {
    n_days_since_last_pull = 180
    repo_matching          = "**"
    tag_matching           = "**"
  }
}

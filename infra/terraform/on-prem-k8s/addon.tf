resource "github_branch" "flux" {
  count = var.git_source.branch != "main" ? 1 : 0

  branch     = var.git_source.branch
  repository = var.git_source.repository

  lifecycle {
    prevent_destroy = true
  }
}

resource "tls_private_key" "flux" {
  algorithm = "ED25519"
}

resource "github_repository_deploy_key" "flux" {
  key        = tls_private_key.flux.public_key_openssh
  read_only  = false
  repository = var.git_source.repository
  title      = "flux"
}

module "k8s_addon" {
  depends_on = [
    github_branch.flux,
    github_repository_deploy_key.flux
  ]

  source = "../modules/k8s-addon"

  addon_override   = local.addon_override
  cluster_domain   = local.cluster_domain
  cluster_endpoint = var.KUBE_HOST
  cluster_name     = local.cluster_name
}

resource "github_branch" "flux" {
  count = var.github_branch != "main" ? 1 : 0

  branch     = var.github_branch
  repository = var.github_repository
}

resource "tls_private_key" "flux" {
  algorithm = "ED25519"
}

resource "github_repository_deploy_key" "flux" {
  key        = tls_private_key.flux.public_key_openssh
  read_only  = false
  repository = var.github_repository
  title      = "flux"
}

module "k8s_addon" {
  depends_on = [
    github_branch.flux,
    github_repository_deploy_key.flux
  ]

  source = "../modules/k8s-addon"

  cilium_override = [
    yamlencode({
      ipv4NativeRoutingCIDR = "10.42.0.0/16"
      ipv6 = {
        enabled = false
      }
    })
  ]
  cluster_domain     = local.cluster_domain
  cluster_endpoint   = var.cluster_endpoint
  cluster_name       = local.cluster_name
  flux_git_repo_path = "clusters/${local.cluster_name}"
}

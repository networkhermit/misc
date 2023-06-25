resource "github_branch" "flux" {
  count = var.github_branch != "main" ? 1 : 0

  branch     = var.github_branch
  repository = var.github_repository

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
  repository = var.github_repository
  title      = "flux"
}

module "k8s_addon" {
  count = local.infra.control_plane_spec.count > 0 ? 1 : 0
  depends_on = [
    github_branch.flux,
    github_repository_deploy_key.flux,
    local_sensitive_file.kubeconfig
  ]

  source = "../modules/k8s-addon"

  cilium_override    = local.addon.cilium_override
  cluster_dns_domain = local.cluster_dns_domain
  cluster_endpoint   = module.do_talos.cluster_endpoint
  cluster_name       = local.cluster_name
  flux_git_repo_path = "clusters/${local.cluster_name}"
}

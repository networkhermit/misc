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
  count = local.install_k8s_addon ? 1 : 0

  source = "../modules/k8s-addon"

  cluster_domain          = "fleet.local"
  cluster_endpoint        = module.talos_bootstrap.cluster_endpoint
  flux_bootstrap_git_path = "clusters/fleet"
}

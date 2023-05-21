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
  depends_on = [
    github_branch.flux,
    github_repository_deploy_key.flux,
    local_sensitive_file.kubeconfig
  ]

  source = "../modules/k8s-addon"

  cilium_override    = [file("../../manifest/cilium-talos.yaml")]
  cluster_domain     = local.cluster_domain
  cluster_endpoint   = module.talos_bootstrap.cluster_endpoint
  cluster_name       = local.cluster_name
  flux_git_repo_path = "clusters/${local.cluster_name}"
}

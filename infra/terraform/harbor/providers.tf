provider "flux" {
  kubernetes = {
    client_certificate     = var.KUBE_CLIENT_CERT_DATA
    cluster_ca_certificate = var.KUBE_CLUSTER_CA_CERT_DATA
    config_path            = var.KUBE_CLIENT_KEY_DATA
    host                   = var.KUBE_HOST
  }
  git = {
    branch = var.github_branch
    ssh = {
      private_key = tls_private_key.flux.private_key_pem
      username    = "git"
    }
    url = "ssh://git@github.com/${var.GITHUB_OWNER}/${var.github_repository}.git"
  }
}

provider "github" {}

provider "helm" {
  kubernetes {}
}

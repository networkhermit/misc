provider "flux" {
  kubernetes = {
    client_certificate     = var.KUBE_CLIENT_CERT_DATA
    client_key             = var.KUBE_CLIENT_KEY_DATA
    cluster_ca_certificate = var.KUBE_CLUSTER_CA_CERT_DATA
    host                   = var.KUBE_HOST
  }
  git = {
    branch = var.git_source.branch
    ssh = {
      private_key = tls_private_key.flux.private_key_pem
      username    = "git"
    }
    url = "ssh://git@github.com/${var.GITHUB_OWNER}/${var.git_source.repository}.git"
  }
}

provider "github" {}

provider "helm" {
  kubernetes {}
}

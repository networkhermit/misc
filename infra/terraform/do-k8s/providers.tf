provider "digitalocean" {}

provider "flux" {
  kubernetes = {
    config_path = var.KUBE_CONFIG_PATH
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
  kubernetes {
    config_path = var.KUBE_CONFIG_PATH
  }
}

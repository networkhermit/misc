provider "flux" {
  kubernetes = {
    config_path = var.KUBE_CONFIG_PATH
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

provider "github" {
  owner = var.GITHUB_OWNER
  token = var.GITHUB_TOKEN
}

provider "helm" {
  kubernetes {
    config_path = var.KUBE_CONFIG_PATH
  }
}

variable "DIGITALOCEAN_TOKEN" {
  type = string
}

provider "digitalocean" {
  token = var.DIGITALOCEAN_TOKEN
}

provider "helm" {
  kubernetes {
    config_path = "vault/kubeconfig"
  }
}

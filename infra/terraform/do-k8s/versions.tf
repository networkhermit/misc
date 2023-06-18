terraform {
  backend "s3" {
    bucket                      = "infra"
    force_path_style            = true
    key                         = "terraform/do-k8s/terraform.tfstate"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
  }
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.28.1"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "1.0.0-rc.5"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.28.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.10.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4.0"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "~> 0.2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }
  }
  required_version = ">= 1.0"
}

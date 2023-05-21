terraform {
  required_version = ">= 1.0"
  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = "1.0.0-rc.3"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.25.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.9.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }
  }
}

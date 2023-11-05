terraform {
  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = ">= 1.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11.0"
    }
  }
  required_version = ">= 1.5"
}

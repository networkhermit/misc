terraform {
  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = ">= 1.4"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.15"
    }
  }
  required_version = ">= 1.8"
}

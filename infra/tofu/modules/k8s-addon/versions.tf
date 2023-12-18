terraform {
  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = ">= 1.2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.12"
    }
  }
  required_version = ">= 1.6"
}

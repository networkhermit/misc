terraform {
  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = ">= 1.5"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.17"
    }
  }
  required_version = ">= 1.8"
}

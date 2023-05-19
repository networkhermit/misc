terraform {
  required_version = ">= 1.0"
  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = ">= 1.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.9"
    }
  }
}

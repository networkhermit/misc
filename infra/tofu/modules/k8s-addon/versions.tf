terraform {
  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = ">= 1.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.13"
    }
  }
  required_version = ">= 1.6"
}

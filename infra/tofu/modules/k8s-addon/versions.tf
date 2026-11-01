terraform {
  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = ">= 1.10"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 3.3"
    }
  }
  required_version = ">= 1.11"
}

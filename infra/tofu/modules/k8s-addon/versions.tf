terraform {
  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = ">= 1.9"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 3.2"
    }
  }
  required_version = ">= 1.11"
}

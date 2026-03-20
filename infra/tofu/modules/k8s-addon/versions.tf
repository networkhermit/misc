terraform {
  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = ">= 1.8"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 3.1"
    }
  }
  required_version = ">= 1.11"
}

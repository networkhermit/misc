terraform {
  backend "s3" {
    bucket                      = "infra"
    key                         = "tofu/harbor/tofu-state.json"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_s3_checksum            = true
    use_path_style              = true
  }
  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = "~> 1.3.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.2.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.5"
    }
  }
  required_version = ">= 1.6"
}

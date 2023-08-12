terraform {
  backend "s3" {
    bucket                      = "infra"
    force_path_style            = true
    key                         = "terraform/cloudflare/terraform.tfstate"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
  }
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.12.0"
    }
    doppler = {
      source  = "DopplerHQ/doppler"
      version = "~> 1.2.3"
    }
  }
  required_version = ">= 1.5"
}

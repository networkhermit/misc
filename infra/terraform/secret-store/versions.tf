terraform {
  backend "s3" {
    bucket                      = "infra"
    force_path_style            = true
    key                         = "terraform/secret-store/terraform.tfstate"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
  }
  required_providers {
    doppler = {
      source  = "DopplerHQ/doppler"
      version = "~> 1.2.3"
    }
  }
  required_version = ">= 1.5"
}

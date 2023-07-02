terraform {
  backend "s3" {
    bucket                      = "infra"
    force_path_style            = true
    key                         = "terraform/harbor/goharbor/terraform.tfstate"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
  }
  required_providers {
    harbor = {
      source  = "goharbor/harbor"
      version = "~> 3.9.3"
    }
  }
  required_version = ">= 1.5"
}

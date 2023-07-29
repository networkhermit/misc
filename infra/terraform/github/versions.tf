terraform {
  backend "s3" {
    bucket                      = "infra"
    force_path_style            = true
    key                         = "terraform/github/terraform.tfstate"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
  }
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.32.0"
    }
  }
  required_version = ">= 1.5"
}

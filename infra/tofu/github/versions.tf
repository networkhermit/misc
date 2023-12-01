terraform {
  backend "s3" {
    bucket                      = "infra"
    key                         = "tofu/github/tofu-state.json"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_s3_checksum            = true
    use_path_style              = true
  }
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.42.0"
    }
  }
  required_version = ">= 1.6"
}

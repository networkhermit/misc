terraform {
  backend "s3" {
    bucket                      = "infra"
    key                         = "tofu/do-k8s/tofu-state.json"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_s3_checksum            = true
    use_path_style              = true
  }
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.40.0"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "~> 0.5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.5"
    }
  }
  required_version = ">= 1.6"
}

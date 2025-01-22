terraform {
  backend "s3" {
    bucket                      = var.state_backend_s3_bucket
    key                         = var.state_backend_s3_key
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_s3_checksum            = true
    use_path_style              = true
  }
  encryption {
    key_provider "pbkdf2" "main" {
      passphrase = var.state_encryption_passphrase
    }

    method "aes_gcm" "main" {
      keys = key_provider.pbkdf2.main
    }

    state {
      enforced = true
      method   = method.aes_gcm.main
    }

    plan {
      enforced = true
      method   = method.aes_gcm.main
    }
  }
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.5.0"
    }
  }
  required_version = ">= 1.8"
}

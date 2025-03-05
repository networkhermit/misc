terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.49"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0"
    }
  }
  required_version = ">= 1.8"
}

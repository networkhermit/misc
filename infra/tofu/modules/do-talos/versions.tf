terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.95"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.3"
    }
  }
  required_version = ">= 1.11"
}

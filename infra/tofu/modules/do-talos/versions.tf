terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.80"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.2"
    }
  }
  required_version = ">= 1.11"
}

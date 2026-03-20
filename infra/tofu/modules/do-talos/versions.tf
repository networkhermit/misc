terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.79"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.2"
    }
  }
  required_version = ">= 1.11"
}

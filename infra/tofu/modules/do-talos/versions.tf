terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.106"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.4"
    }
  }
  required_version = ">= 1.11"
}

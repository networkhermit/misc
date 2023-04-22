resource "digitalocean_vpc" "vpc" {
  ip_range = var.vpc_cidr
  name     = "${var.cluster_name}-vpc"
  region   = var.region
}

resource "digitalocean_tag" "cluster_name" {
  name = var.cluster_name
}

resource "digitalocean_tag" "control_plane" {
  name = "control-plane"
}

resource "digitalocean_tag" "talos" {
  name = "talos"
}

resource "digitalocean_tag" "worker" {
  name = "worker"
}

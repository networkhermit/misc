resource "digitalocean_droplet" "control_plane" {
  count = var.cluster_spec.control_plane.count

  image    = digitalocean_custom_image.talos.id
  ipv6     = false
  name     = "${var.cluster_name}-control-plane-${count.index}"
  region   = var.region
  size     = var.cluster_spec.control_plane.type
  ssh_keys = [digitalocean_ssh_key.dummy.fingerprint]
  tags     = [digitalocean_tag.talos.name, digitalocean_tag.cluster_name.name, digitalocean_tag.control_plane.name]
  vpc_uuid = digitalocean_vpc.vpc.id
}

resource "digitalocean_droplet" "worker" {
  count = var.cluster_spec.worker.count

  image    = digitalocean_custom_image.talos.id
  ipv6     = false
  name     = "${var.cluster_name}-worker-${count.index}"
  region   = var.region
  size     = var.cluster_spec.worker.type
  ssh_keys = [digitalocean_ssh_key.dummy.fingerprint]
  tags     = [digitalocean_tag.talos.name, digitalocean_tag.cluster_name.name, digitalocean_tag.worker.name]
  vpc_uuid = digitalocean_vpc.vpc.id
}

resource "digitalocean_droplet" "control_plane" {
  count = var.control_plane_spec.count

  image    = digitalocean_custom_image.talos.id
  ipv6     = false
  name     = "${var.cluster_name}-control-plane-${count.index}"
  region   = var.region
  size     = var.control_plane_spec.type
  ssh_keys = [digitalocean_ssh_key.dummy.fingerprint]
  tags     = [digitalocean_tag.talos.name, digitalocean_tag.cluster_name.name, digitalocean_tag.control_plane.name]
  vpc_uuid = digitalocean_vpc.vpc.id
}

resource "digitalocean_droplet" "worker" {
  count = var.worker_spec.count

  image    = digitalocean_custom_image.talos.id
  ipv6     = false
  name     = "${var.cluster_name}-worker-${count.index}"
  region   = var.region
  size     = var.worker_spec.type
  ssh_keys = [digitalocean_ssh_key.dummy.fingerprint]
  tags     = [digitalocean_tag.talos.name, digitalocean_tag.cluster_name.name, digitalocean_tag.worker.name]
  vpc_uuid = digitalocean_vpc.vpc.id
}

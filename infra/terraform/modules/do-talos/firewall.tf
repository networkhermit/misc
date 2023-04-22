resource "digitalocean_firewall" "internal" {
  name = "${var.cluster_name}-internal"
  tags = [digitalocean_tag.talos.name]

  inbound_rule {
    protocol    = "icmp"
    source_tags = [digitalocean_tag.talos.name]
  }
  inbound_rule {
    port_range  = "1-65535"
    protocol    = "tcp"
    source_tags = [digitalocean_tag.talos.name]
  }
  inbound_rule {
    port_range  = "1-65535"
    protocol    = "udp"
    source_tags = [digitalocean_tag.talos.name]
  }
  inbound_rule {
    protocol         = "icmp"
    source_addresses = var.extra_internal_allowed_cidr
  }
  inbound_rule {
    port_range       = "1-65535"
    protocol         = "tcp"
    source_addresses = var.extra_internal_allowed_cidr
  }
  inbound_rule {
    port_range       = "1-65535"
    protocol         = "udp"
    source_addresses = var.extra_internal_allowed_cidr
  }
}

resource "digitalocean_firewall" "internet" {
  name = "${var.cluster_name}-internet"
  tags = [digitalocean_tag.talos.name]

  outbound_rule {
    destination_addresses = ["0.0.0.0/0", "::/0"]
    protocol              = "icmp"
  }
  outbound_rule {
    destination_addresses = ["0.0.0.0/0", "::/0"]
    port_range            = "1-65535"
    protocol              = "tcp"
  }
  outbound_rule {
    destination_addresses = ["0.0.0.0/0", "::/0"]
    port_range            = "1-65535"
    protocol              = "udp"
  }
}

resource "digitalocean_firewall" "kubernetes_api" {
  count = var.control_plane_count > 1 ? 0 : 1

  name = "${var.cluster_name}-kubernetes-api"
  tags = [digitalocean_tag.control_plane.name]

  inbound_rule {
    port_range       = "6443"
    protocol         = "tcp"
    source_addresses = var.kubernetes_api_allowed_cidr
  }
}

resource "digitalocean_firewall" "kubernetes_api_lb" {
  count = var.control_plane_count > 1 ? 1 : 0

  name = "${var.cluster_name}-kubernetes-api-lb"
  tags = [digitalocean_tag.control_plane.name]

  inbound_rule {
    port_range                = "6443"
    protocol                  = "tcp"
    source_load_balancer_uids = digitalocean_loadbalancer.kubernetes_api[*].id
  }
}

resource "digitalocean_firewall" "talos_api" {
  name = "${var.cluster_name}-talos-api"
  tags = [digitalocean_tag.talos.name]

  inbound_rule {
    port_range       = "50000"
    protocol         = "tcp"
    source_addresses = var.talos_api_allowed_cidr
  }
}

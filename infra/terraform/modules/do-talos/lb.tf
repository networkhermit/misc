resource "digitalocean_loadbalancer" "k8s_api" {
  count = var.control_plane_spec.count > 1 ? 1 : 0

  droplet_tag = "control-plane"
  name        = "${var.cluster_name}-kubernetes-api"
  region      = var.region
  size_unit   = var.k8s_api_lb_size
  vpc_uuid    = digitalocean_vpc.vpc.id

  forwarding_rule {
    entry_port      = 443
    entry_protocol  = "tcp"
    target_port     = 6443
    target_protocol = "tcp"
  }
  healthcheck {
    healthy_threshold = 2
    port              = 6443
    protocol          = "tcp"
  }
}

output "cluster_endpoint" {
  value = var.control_plane_count > 1 ? "https://${digitalocean_loadbalancer.kubernetes_api[0].ip}:443" : var.control_plane_count > 0 ? "https://${digitalocean_droplet.control_plane[0].ipv4_address}:6443" : null
}

output "control_plane_nodes" {
  value = { for o in digitalocean_droplet.control_plane : o.name => o.ipv4_address }
}

output "worker_nodes" {
  value = { for o in digitalocean_droplet.worker : o.name => o.ipv4_address }
}

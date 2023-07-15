output "cluster_endpoint" {
  value = var.cluster_spec.control_plane.count > 1 ? "https://${digitalocean_loadbalancer.k8s_api[0].ip}:443" : var.cluster_spec.control_plane.count > 0 ? "https://${digitalocean_droplet.control_plane[0].ipv4_address}:6443" : null
}

output "node_list" {
  value = {
    control_plane = { for o in digitalocean_droplet.control_plane : o.name => o.ipv4_address }
    worker        = { for o in digitalocean_droplet.worker : o.name => o.ipv4_address }
  }
}

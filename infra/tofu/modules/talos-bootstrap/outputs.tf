data "talos_client_configuration" "default" {
  client_configuration = talos_machine_secrets.default.client_configuration
  cluster_name         = var.cluster_name
  endpoints            = local.control_plane_nodes

  lifecycle {
    enabled = length(local.control_plane_nodes) > 0
  }
}

resource "talos_cluster_kubeconfig" "default" {
  depends_on = [talos_machine_bootstrap.control_plane_etcd]

  client_configuration = talos_machine_secrets.default.client_configuration
  node                 = local.control_plane_nodes[0]

  lifecycle {
    enabled = length(local.control_plane_nodes) > 0
  }
}

output "kubeconfig" {
  value     = try(talos_cluster_kubeconfig.default.kubeconfig_raw, null)
  sensitive = true
}

output "kubernetes_client_configuration" {
  value     = try(talos_cluster_kubeconfig.default.kubernetes_client_configuration, null)
  sensitive = true
}

output "talosconfig" {
  value     = try(data.talos_client_configuration.default.talos_config, null)
  sensitive = true
}

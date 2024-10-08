data "talos_client_configuration" "default" {
  count = length(local.control_plane_nodes) > 0 ? 1 : 0

  client_configuration = talos_machine_secrets.default.client_configuration
  cluster_name         = var.cluster_name
  endpoints            = local.control_plane_nodes
}

resource "talos_cluster_kubeconfig" "default" {
  count      = length(local.control_plane_nodes) > 0 ? 1 : 0
  depends_on = [talos_machine_bootstrap.control_plane_etcd]

  client_configuration = talos_machine_secrets.default.client_configuration
  node                 = local.control_plane_nodes[0]
}

output "kubeconfig" {
  value     = one(talos_cluster_kubeconfig.default[*].kubeconfig_raw)
  sensitive = true
}

output "kubernetes_client_configuration" {
  value     = one(talos_cluster_kubeconfig.default[*].kubernetes_client_configuration)
  sensitive = true
}

output "talosconfig" {
  value     = one(data.talos_client_configuration.default[*].talos_config)
  sensitive = true
}

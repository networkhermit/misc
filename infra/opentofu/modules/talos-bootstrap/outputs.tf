data "talos_client_configuration" "default" {
  count = length(local.control_plane_nodes) > 0 ? 1 : 0

  client_configuration = talos_machine_secrets.default.client_configuration
  cluster_name         = var.cluster_name
  endpoints            = local.control_plane_nodes
}

data "talos_cluster_kubeconfig" "default" {
  count      = length(local.control_plane_nodes) > 0 ? 1 : 0
  depends_on = [talos_machine_bootstrap.control_plane_etcd]

  client_configuration = talos_machine_secrets.default.client_configuration
  node                 = local.control_plane_nodes[0]
}

output "kube_config" {
  value     = one(data.talos_cluster_kubeconfig.default[*].kubernetes_client_configuration)
  sensitive = true
}

output "kube_config_raw" {
  value     = one(data.talos_cluster_kubeconfig.default[*].kubeconfig_raw)
  sensitive = true
}

output "talosconfig" {
  value     = one(data.talos_client_configuration.default[*].talos_config)
  sensitive = true
}

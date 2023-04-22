data "talos_machine_configuration" "worker" {
  cluster_endpoint   = var.cluster_endpoint
  cluster_name       = var.cluster_name
  config_patches     = var.config_patches
  kubernetes_version = var.kubernetes_version
  machine_secrets    = talos_machine_secrets.default.machine_secrets
  machine_type       = "worker"
  talos_version      = talos_machine_secrets.default.talos_version
}

resource "talos_machine_configuration_apply" "worker" {
  for_each = var.worker_nodes

  client_configuration        = talos_machine_secrets.default.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  node                        = each.value
}

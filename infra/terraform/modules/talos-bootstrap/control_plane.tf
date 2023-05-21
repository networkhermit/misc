data "talos_machine_configuration" "control_plane" {
  cluster_endpoint = var.cluster_endpoint
  cluster_name     = var.cluster_name
  config_patches = concat(
    [
      file("${path.module}/../../../manifest/talos-machine-patch.yaml"),
      yamlencode({
        cluster = {
          network = {
            dnsDomain = var.cluster_domain
          }
        }
      })
    ],
    var.machine_override,
    var.control_plane_override
  )
  kubernetes_version = var.kubernetes_version
  machine_secrets    = talos_machine_secrets.default.machine_secrets
  machine_type       = "controlplane"
  talos_version      = talos_machine_secrets.default.talos_version
}

resource "talos_machine_configuration_apply" "control_plane" {
  for_each = var.control_plane_nodes

  client_configuration        = talos_machine_secrets.default.client_configuration
  machine_configuration_input = data.talos_machine_configuration.control_plane.machine_configuration
  node                        = each.value
}

resource "talos_machine_bootstrap" "control_plane_etcd" {
  count      = length(local.control_plane_nodes) > 0 ? 1 : 0
  depends_on = [talos_machine_configuration_apply.control_plane]

  client_configuration = talos_machine_secrets.default.client_configuration
  endpoint             = local.control_plane_nodes[0]
  node                 = local.control_plane_nodes[0]
}

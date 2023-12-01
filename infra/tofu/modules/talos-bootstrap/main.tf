resource "talos_machine_secrets" "default" {
  talos_version = var.pinned_version.talos
}

locals {
  base_config_patches = concat(
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
    var.talos_override.machine
  )
  config_patches = {
    control_plane = concat(
      local.base_config_patches,
      var.talos_override.control_plane
    )
    worker = concat(
      local.base_config_patches,
      var.talos_override.worker
    )
  }
  control_plane_nodes = values(var.node_list.control_plane)
}

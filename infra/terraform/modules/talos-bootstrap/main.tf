resource "talos_machine_secrets" "default" {
  talos_version = var.talos_version
}

locals {
  base_config_patches = concat(
    [
      file("${path.module}/../../../manifest/talos-machine-patch.yaml"),
      yamlencode({
        cluster = {
          network = {
            dnsDomain = var.cluster_dns_domain
          }
        }
      })
    ],
    var.machine_override
  )
  config_patches = {
    control_plane = concat(
      local.base_config_patches,
      var.control_plane_override
    )
    worker = concat(
      local.base_config_patches,
      var.worker_override
    )
  }
  control_plane_nodes = values(var.control_plane_nodes)
}

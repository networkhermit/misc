resource "talos_machine_secrets" "default" {
  talos_version = var.talos_version
}

locals {
  control_plane_nodes = values(var.control_plane_nodes)
}

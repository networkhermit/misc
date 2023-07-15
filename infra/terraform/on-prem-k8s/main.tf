locals {
  addon_override = {
    flux = {
      watch_path = "clusters/${local.cluster_name}"
    }
  }
  cluster_domain = "${local.cluster_name}.local"
  cluster_name   = "fleet"
}

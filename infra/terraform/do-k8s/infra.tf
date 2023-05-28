module "do_talos" {
  source = "../modules/do-talos"

  cluster_name        = local.cluster_name
  control_plane_spec  = local.infra.control_plane_spec
  extra_internal_cidr = local.infra.extra_internal_cidr
  talos_version       = local.infra.talos_version
  worker_spec         = local.infra.worker_spec
}

module "talos_bootstrap" {
  source = "../modules/talos-bootstrap"

  cluster_domain      = local.cluster_domain
  cluster_endpoint    = module.do_talos.cluster_endpoint
  cluster_name        = local.cluster_name
  control_plane_nodes = module.do_talos.control_plane_nodes
  kubernetes_version  = local.infra.kubernetes_version
  machine_override    = local.talos.machine_override
  talos_version       = local.infra.talos_version
  worker_nodes        = module.do_talos.worker_nodes
}

resource "local_sensitive_file" "kubeconfig" {
  count = local.infra.control_plane_spec.count > 0 ? 1 : 0

  content         = module.talos_bootstrap.kube_config_raw
  file_permission = "0600"
  filename        = var.KUBE_CONFIG_PATH
}

resource "local_sensitive_file" "talosconfig" {
  count = local.infra.control_plane_spec.count > 0 ? 1 : 0

  content         = module.talos_bootstrap.talosconfig
  file_permission = "0600"
  filename        = var.TALOSCONFIG
}

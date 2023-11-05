module "do_talos" {
  source = "../modules/do-talos"

  cluster_name       = local.cluster_name
  cluster_spec       = local.infra.cluster_spec
  firewall_allowlist = local.infra.firewall_allowlist
  pinned_version     = local.infra.pinned_version
}

module "talos_bootstrap" {
  source = "../modules/talos-bootstrap"

  cluster_domain   = local.cluster_domain
  cluster_endpoint = module.do_talos.cluster_endpoint
  cluster_name     = local.cluster_name
  node_list        = module.do_talos.node_list
  pinned_version   = local.infra.pinned_version
  talos_override   = local.talos_override
}

resource "local_sensitive_file" "kubeconfig" {
  count = local.infra.cluster_spec.control_plane.count > 0 ? 1 : 0

  content         = module.talos_bootstrap.kube_config_raw
  file_permission = "0600"
  filename        = var.KUBE_CONFIG_PATH
}

resource "local_sensitive_file" "talosconfig" {
  count = local.infra.cluster_spec.control_plane.count > 0 ? 1 : 0

  content         = module.talos_bootstrap.talosconfig
  file_permission = "0600"
  filename        = var.TALOSCONFIG
}

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

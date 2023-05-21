module "do_talos" {
  source = "../modules/do-talos"

  cluster_name                = local.cluster_name
  control_plane_count         = local.control_plane_count
  extra_internal_allowed_cidr = ["10.24.0.0/16"]
  talos_version               = local.talos_version
  worker_count                = local.worker_count
}

module "talos_bootstrap" {
  source = "../modules/talos-bootstrap"

  cluster_domain   = local.cluster_domain
  cluster_endpoint = module.do_talos.cluster_endpoint
  cluster_name     = local.cluster_name
  machine_override = [
    yamlencode({
      cluster = {
        allowSchedulingOnControlPlanes = true
      }
    })
  ]
  control_plane_nodes = module.do_talos.control_plane_nodes
  kubernetes_version  = local.kubernetes_version
  talos_version       = local.talos_version
  worker_nodes        = module.do_talos.worker_nodes
}

resource "local_sensitive_file" "kubeconfig" {
  count = local.control_plane_count > 0 ? 1 : 0

  content         = module.talos_bootstrap.kubeconfig
  file_permission = "0600"
  filename        = local.kube_config_path
}

resource "local_sensitive_file" "talosconfig" {
  count = local.control_plane_count > 0 ? 1 : 0

  content         = module.talos_bootstrap.talosconfig
  file_permission = "0600"
  filename        = local.talos_config_path
}

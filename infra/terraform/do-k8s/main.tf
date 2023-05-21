locals {
  cluster_domain      = "fleet.local"
  cluster_name        = "fleet"
  control_plane_count = 1
  install_k8s_addon   = true && local.control_plane_count > 0
  kube_config_path    = "vault/kubeconfig"
  kubernetes_version  = "1.27.2"
  talos_config_path   = "vault/talosconfig"
  talos_version       = "v1.4.4"
  worker_count        = 1
}

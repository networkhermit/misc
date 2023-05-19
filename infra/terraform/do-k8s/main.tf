locals {
  cluster_name        = "fleet"
  control_plane_count = 1
  install_k8s_addon   = true
  kube_config_path    = "vault/kubeconfig"
  kubernetes_version  = "1.27.1"
  talos_config_path   = "vault/talosconfig"
  talos_version       = "v1.4.4"
  worker_count        = 1
}

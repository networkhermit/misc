output "control_plane_nodes" {
  value = module.do_talos.control_plane_nodes
}

output "kubeconfig" {
  value     = module.talos_bootstrap.kube_config_raw
  sensitive = true
}

output "talosconfig" {
  value     = module.talos_bootstrap.talosconfig
  sensitive = true
}

output "worker_nodes" {
  value = module.do_talos.worker_nodes
}

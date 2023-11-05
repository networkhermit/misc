output "kubeconfig" {
  value     = module.talos_bootstrap.kube_config_raw
  sensitive = true
}

output "node_list" {
  value = module.do_talos.node_list
}

output "talosconfig" {
  value     = module.talos_bootstrap.talosconfig
  sensitive = true
}

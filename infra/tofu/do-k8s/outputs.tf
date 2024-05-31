output "kubeconfig" {
  value     = module.talos_bootstrap.kubeconfig
  sensitive = true
}

output "kubernetes_client_configuration" {
  value     = module.talos_bootstrap.kubernetes_client_configuration
  sensitive = true
}

output "node_list" {
  value = module.do_talos.node_list
}

output "talosconfig" {
  value     = module.talos_bootstrap.talosconfig
  sensitive = true
}

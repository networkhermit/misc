output "kubeconfig" {
  value     = module.talos_bootstrap.kubeconfig
  sensitive = true
}

output "talosconfig" {
  value     = module.talos_bootstrap.talosconfig
  sensitive = true
}

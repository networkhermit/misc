output "doppler_service_token" {
  sensitive = true
  value = {
    for o in [
      doppler_service_token.local_k3s_dex_secret,
      doppler_service_token.local_k3s_grafana_secret,
      doppler_service_token.local_k3s_harbor_secret,
    ] : o.config => o.key
  }
}

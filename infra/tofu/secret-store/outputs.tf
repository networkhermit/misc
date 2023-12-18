output "doppler_service_token" {
  sensitive = true
  value = {
    for o in concat(
      doppler_service_token.harbor_dex_secret,
      doppler_service_token.harbor_harbor_secret,
      doppler_service_token.harbor_minio_secret,
      doppler_service_token.harbor_weave_gitops_secret
    ) : o.config => o.key
  }
}

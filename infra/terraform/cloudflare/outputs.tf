output "doppler_service_token" {
  sensitive = true
  value     = { for o in doppler_service_token.cloudflare_credential : o.config => o.key }
}

output "name_servers" {
  value = {
    (cloudflare_zone.dev.zone) = cloudflare_zone.dev.name_servers
  }
}

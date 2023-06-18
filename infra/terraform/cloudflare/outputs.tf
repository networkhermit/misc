output "acme_clients_token" {
  sensitive = true
  value     = { for o in cloudflare_api_token.acme_dns_challenge : o.name => o.value }
}

output "name_servers" {
  value = {
    "${cloudflare_zone.dev.zone}" = cloudflare_zone.dev.name_servers
  }
}

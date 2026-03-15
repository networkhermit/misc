data "cloudflare_api_token_permission_groups_list" "dns_write" {
  max_items = 1
  name      = urlencode("DNS Write")
  scope     = "com.cloudflare.api.account.zone"
}

data "cloudflare_api_token_permission_groups_list" "zone_read" {
  max_items = 1
  name      = urlencode("Zone Read")
  scope     = "com.cloudflare.api.account.zone"
}

resource "cloudflare_api_token" "acme_dns_challenge" {
  for_each = { for o in var.acme_clients.environment : o.uuid => o }

  expires_on = try(each.value.expires_on, null)
  name       = "${each.value.name}-acme"
  not_before = try(each.value.not_before, null)

  policies = [
    {
      effect = "allow"
      permission_groups = [
        for o in concat(
          data.cloudflare_api_token_permission_groups_list.dns_write.result,
          data.cloudflare_api_token_permission_groups_list.zone_read.result
        ) : { id = o.id }
      ]
      resources = jsonencode({
        "com.cloudflare.api.account.zone.${cloudflare_zone.dev.id}" = "*"
      })
    }
  ]
}

resource "doppler_config" "cloudflare_credential" {
  for_each = { for o in var.acme_clients.environment : o.uuid => o }

  environment = each.value.name
  name        = "${each.value.name}_cloudflare_credential"
  project     = var.acme_clients.project
}

resource "doppler_secret" "cloudflare_credential" {
  for_each = { for o in var.acme_clients.environment : o.uuid => o }

  config  = doppler_config.cloudflare_credential[each.key].name
  name    = "CLOUDFLARE_API_TOKEN"
  project = var.acme_clients.project
  value   = cloudflare_api_token.acme_dns_challenge[each.key].value
}

resource "doppler_service_token" "cloudflare_credential" {
  for_each = { for o in var.acme_clients.environment : o.uuid => o }

  access  = "read"
  config  = doppler_config.cloudflare_credential[each.key].name
  name    = doppler_config.cloudflare_credential[each.key].environment
  project = var.acme_clients.project
}

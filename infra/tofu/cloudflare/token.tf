data "cloudflare_api_token_permission_groups" "all" {}

resource "cloudflare_api_token" "acme_dns_challenge" {
  for_each = { for o in var.acme_clients.environment : o.uuid => o }

  expires_on = try(each.value.expires_on, null)
  name       = "${each.value.name}-acme"
  not_before = try(each.value.not_before, null)

  policy {
    permission_groups = [
      data.cloudflare_api_token_permission_groups.all.zone["DNS Write"],
      data.cloudflare_api_token_permission_groups.all.zone["Zone Read"],
    ]
    resources = {
      "com.cloudflare.api.account.zone.${cloudflare_zone.dev.id}" = "*"
    }
  }
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

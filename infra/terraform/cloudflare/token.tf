data "cloudflare_api_token_permission_groups" "all" {}

resource "cloudflare_api_token" "acme_dns_challenge" {
  for_each = { for o in var.acme_clients : o.uuid => o }

  expires_on = try(each.value.expires_on, null)
  name       = "${each.value.name}-acme"
  not_before = try(each.value.not_before, null)

  policy {
    permission_groups = [
      data.cloudflare_api_token_permission_groups.all.zone["DNS Write"],
    ]
    resources = {
      "com.cloudflare.api.account.zone.${cloudflare_zone.dev.id}" = "*"
    }
  }
}

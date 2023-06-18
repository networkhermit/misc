resource "cloudflare_zone" "dev" {
  account_id = local.cloudflare_accounts[var.cloudflare_account_name].id
  plan       = "free"
  zone       = var.domain
}

resource "cloudflare_record" "dev" {
  for_each = { for o in var.records : o.uuid => o }

  name     = each.value.name
  priority = try(each.value.priority, null)
  ttl      = each.value.ttl
  type     = each.value.type
  value    = each.value.value
  zone_id  = cloudflare_zone.dev.id
}

resource "cloudflare_zone" "dev" {
  account_id = local.cloudflare_accounts[var.cloudflare_account_name].id
  plan       = "free"
  zone       = var.zone_records.domain
}

resource "cloudflare_record" "dev" {
  for_each = { for o in var.zone_records.records : o.uuid => o }

  content  = each.value.content
  name     = each.value.name
  priority = try(each.value.priority, null)
  ttl      = each.value.ttl
  type     = each.value.type
  zone_id  = cloudflare_zone.dev.id
}

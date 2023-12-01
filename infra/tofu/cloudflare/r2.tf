resource "cloudflare_r2_bucket" "infra" {
  account_id = local.cloudflare_accounts[var.cloudflare_account_name].id
  location   = "APAC"
  name       = "infra"

  lifecycle {
    prevent_destroy = true
  }
}

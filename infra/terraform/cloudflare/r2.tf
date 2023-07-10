resource "cloudflare_r2_bucket" "infra" {
  account_id = data.cloudflare_accounts.main.accounts[0].id
  location   = "APAC"
  name       = "infra"

  lifecycle {
    prevent_destroy = true
  }
}

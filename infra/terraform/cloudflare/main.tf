data "cloudflare_accounts" "main" {
  name = var.cloudflare_account_name
}

locals {
  cloudflare_accounts = { for o in data.cloudflare_accounts.main.accounts : o.name => o }
}

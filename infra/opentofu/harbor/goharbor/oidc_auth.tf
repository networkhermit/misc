resource "harbor_config_auth" "oidc" {
  count = var.oidc_credential != null ? 1 : 0

  auth_mode          = "oidc_auth"
  oidc_admin_group   = var.oidc_credential.admin_group
  oidc_auto_onboard  = true
  oidc_client_id     = var.oidc_credential.client_id
  oidc_client_secret = var.oidc_credential.client_secret
  oidc_endpoint      = var.oidc_credential.endpoint
  oidc_groups_claim  = "groups"
  oidc_name          = "dex"
  oidc_scope         = "email,groups,offline_access,openid,profile"
  oidc_user_claim    = "preferred_username"
  oidc_verify_cert   = true
  primary_auth_mode  = false
}

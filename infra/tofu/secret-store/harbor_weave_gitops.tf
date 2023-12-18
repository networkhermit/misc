resource "doppler_config" "harbor_weave_gitops_secret" {
  count = lookup(var.weave_gitops_secret, doppler_environment.harbor.slug, null) != null ? 1 : 0

  environment = doppler_environment.harbor.slug
  name        = "${doppler_environment.harbor.slug}_weave_gitops_secret"
  project     = doppler_project.infra.id
}

resource "doppler_secret" "harbor_weave_gitops_secret" {
  for_each = try(var.weave_gitops_secret[doppler_environment.harbor.slug].cluster_user_auth, {})

  config  = doppler_config.harbor_weave_gitops_secret[0].name
  name    = each.key
  project = doppler_project.infra.id
  value   = each.value
}

resource "doppler_service_token" "harbor_weave_gitops_secret" {
  count = lookup(var.weave_gitops_secret, doppler_environment.harbor.slug, null) != null ? 1 : 0

  access  = "read"
  config  = doppler_config.harbor_weave_gitops_secret[0].name
  name    = doppler_config.harbor_weave_gitops_secret[0].environment
  project = doppler_project.infra.id
}

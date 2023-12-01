resource "doppler_environment" "on_prem_k8s" {
  name    = "on_prem_k8s"
  project = doppler_project.infra.id
  slug    = "on_prem_k8s"
}

resource "doppler_config" "on_prem_k8s_weave_gitops_secret" {
  count = lookup(var.weave_gitops_secret, doppler_environment.on_prem_k8s.slug, null) != null ? 1 : 0

  environment = doppler_environment.on_prem_k8s.slug
  name        = "${doppler_environment.on_prem_k8s.slug}_weave_gitops_secret"
  project     = doppler_project.infra.id
}

resource "doppler_secret" "on_prem_k8s_weave_gitops_secret" {
  for_each = try(var.weave_gitops_secret[doppler_environment.on_prem_k8s.slug].cluster_user_auth, {})

  config  = doppler_config.on_prem_k8s_weave_gitops_secret[0].name
  name    = each.key
  project = doppler_project.infra.id
  value   = each.value
}

resource "doppler_service_token" "on_prem_k8s_weave_gitops_secret" {
  count = lookup(var.weave_gitops_secret, doppler_environment.on_prem_k8s.slug, null) != null ? 1 : 0

  access  = "read"
  config  = doppler_config.on_prem_k8s_weave_gitops_secret[0].name
  name    = doppler_config.on_prem_k8s_weave_gitops_secret[0].environment
  project = doppler_project.infra.id
}

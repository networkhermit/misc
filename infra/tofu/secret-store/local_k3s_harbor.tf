resource "doppler_config" "local_k3s_harbor_secret" {
  environment = doppler_environment.local_k3s.slug
  name        = "${doppler_environment.local_k3s.slug}_harbor_secret"
  project     = doppler_project.infra.id

  lifecycle {
    enabled = contains(keys(var.harbor_secret), doppler_environment.local_k3s.slug)
  }
}

resource "doppler_secret" "local_k3s_harbor_secret" {
  for_each = try(var.harbor_secret[doppler_environment.local_k3s.slug].harbor, {})

  config  = doppler_config.local_k3s_harbor_secret.name
  name    = each.key
  project = doppler_project.infra.id
  value   = each.value
}

resource "doppler_service_token" "local_k3s_harbor_secret" {
  access  = "read"
  config  = doppler_config.local_k3s_harbor_secret.name
  name    = doppler_config.local_k3s_harbor_secret.environment
  project = doppler_project.infra.id

  lifecycle {
    enabled = contains(keys(var.harbor_secret), doppler_environment.local_k3s.slug)
  }
}

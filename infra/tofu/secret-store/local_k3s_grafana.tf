resource "doppler_config" "local_k3s_grafana_secret" {
  count = lookup(var.grafana_secret, doppler_environment.local_k3s.slug, null) != null ? 1 : 0

  environment = doppler_environment.local_k3s.slug
  name        = "${doppler_environment.local_k3s.slug}_grafana_secret"
  project     = doppler_project.infra.id
}

resource "doppler_secret" "local_k3s_grafana_secret" {
  for_each = merge(try(var.grafana_secret[doppler_environment.local_k3s.slug].grafana_credential, {}), try(var.grafana_secret[doppler_environment.local_k3s.slug].static_clients, {}))

  config  = doppler_config.local_k3s_grafana_secret[0].name
  name    = each.key
  project = doppler_project.infra.id
  value   = each.value
}

resource "doppler_service_token" "local_k3s_grafana_secret" {
  count = lookup(var.grafana_secret, doppler_environment.local_k3s.slug, null) != null ? 1 : 0

  access  = "read"
  config  = doppler_config.local_k3s_grafana_secret[0].name
  name    = doppler_config.local_k3s_grafana_secret[0].environment
  project = doppler_project.infra.id
}

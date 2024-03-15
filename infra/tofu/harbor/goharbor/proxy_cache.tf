resource "harbor_project" "dockerhub" {
  name        = "docker.io"
  registry_id = harbor_registry.dockerhub.registry_id
}

resource "harbor_registry" "dockerhub" {
  endpoint_url  = "https://hub.docker.com"
  name          = "docker.io"
  provider_name = "docker-hub"
}

resource "harbor_project" "gcr" {
  name        = "gcr.io"
  registry_id = harbor_registry.gcr.registry_id
}

resource "harbor_registry" "gcr" {
  endpoint_url  = "https://gcr.io"
  name          = "gcr.io"
  provider_name = "docker-registry"
}

resource "harbor_project" "ghcr" {
  name        = "ghcr.io"
  registry_id = harbor_registry.ghcr.registry_id
}

resource "harbor_registry" "ghcr" {
  endpoint_url  = "https://ghcr.io"
  name          = "ghcr.io"
  provider_name = "github"
}

resource "harbor_project" "k8s_registry" {
  name        = "registry.k8s.io"
  registry_id = harbor_registry.k8s_registry.registry_id
}

resource "harbor_registry" "k8s_registry" {
  endpoint_url  = "https://registry.k8s.io"
  name          = "registry.k8s.io"
  provider_name = "docker-registry"
}

resource "harbor_project" "quay" {
  name        = "quay.io"
  registry_id = harbor_registry.quay.registry_id
}

resource "harbor_registry" "quay" {
  endpoint_url  = "https://quay.io"
  name          = "quay.io"
  provider_name = "quay"
}

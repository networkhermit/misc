resource "digitalocean_custom_image" "talos" {
  distribution = "Unknown OS"
  name         = "Talos ${var.pinned_version.talos}"
  regions      = [var.region]
  tags         = [digitalocean_tag.talos.name]
  url          = "https://github.com/siderolabs/talos/releases/download/${var.pinned_version.talos}/digital-ocean-amd64.raw.gz"
}

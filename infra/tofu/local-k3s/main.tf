locals {
  addon_override = {
    cilium = [
      yamlencode({
        devices               = var.cluster_specific.cilium_devices
        ipv4NativeRoutingCIDR = "10.42.0.0/16"
      })
    ]
  }
}

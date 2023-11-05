locals {
  addon_override = {
    cilium = [
      yamlencode({
        ipv4NativeRoutingCIDR = "10.42.0.0/16"
      })
    ]
  }
}

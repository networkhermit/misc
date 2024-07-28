locals {
  addon_override = {
    cilium = [
      yamlencode({
        MTU                   = 1406
        ipv4NativeRoutingCIDR = "10.42.0.0/16"
      })
    ]
  }
}

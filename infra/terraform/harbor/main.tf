locals {
  addon = {
    cilium_override = [
      yamlencode({
        MTU                   = 1410
        ipv4NativeRoutingCIDR = "10.42.0.0/16"
      })
    ]
  }
  cluster_domain = "cluster.local"
  cluster_name   = "default"
}

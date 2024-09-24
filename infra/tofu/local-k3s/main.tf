locals {
  addon_override = {
    cilium = [
      yamlencode({
        bpf = {
          datapathMode = "netkit"
        }
        devices               = var.cluster_specific.cilium_devices
        ipv4NativeRoutingCIDR = "10.42.0.0/16"
        loadBalancer = {
          mode = "hybrid"
        }
      })
    ]
  }
}

locals {
  addon_override = {
    cilium = [
      yamlencode({
        bpf = {
          datapathMode = "netkit"
        }
        cni = {
          exclusive = false
        }
        gatewayAPI = {
          enabled = false
        }
        ingressController = {
          enabled = false
        }
        ipv4NativeRoutingCIDR = "10.42.0.0/16"
        l7Proxy               = false
        loadBalancer = {
          mode = "hybrid"
        }
      })
    ]
  }
}

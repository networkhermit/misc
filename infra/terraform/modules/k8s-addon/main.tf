resource "helm_release" "kubelet_csr_approver" {
  chart      = "kubelet-csr-approver"
  name       = "kubelet-csr-approver"
  namespace  = "kube-system"
  repository = "https://postfinance.github.io/kubelet-csr-approver"
  version    = "1.0.0"

  values = [
    yamlencode({
      bypassDnsResolution : true
    })
  ]
}

locals {
  k8sServiceCapture = regex("^https?://([0-9]+.[0-9]+.[0-9]+.[0-9]+):([0-9]+)$", var.cluster_endpoint)
}

resource "helm_release" "cilium" {
  chart      = "cilium"
  name       = "cilium"
  namespace  = "kube-system"
  repository = "https://helm.cilium.io"
  version    = "1.13.2"

  values = [
    file("${path.module}/../../../manifest/cilium.yaml"),
    yamlencode({
      cgroup = {
        autoMount = {
          enabled = false
        }
        hostRoot = "/sys/fs/cgroup"
      }
      ipv6 = {
        enabled = false
      }
      k8sServiceHost = local.k8sServiceCapture[0]
      k8sServicePort = local.k8sServiceCapture[1]
      loadBalancer = {
        acceleration : "native"
      }
      securityContext = {
        capabilities = {
          ciliumAgent      = ["CHOWN", "KILL", "NET_ADMIN", "NET_RAW", "IPC_LOCK", "SYS_ADMIN", "SYS_RESOURCE", "DAC_OVERRIDE", "FOWNER", "SETGID", "SETUID"]
          cleanCiliumState = ["NET_ADMIN", "SYS_ADMIN", "SYS_RESOURCE"]
        }
      }
    })
  ]
}

resource "flux_bootstrap_git" "fleet" {
  cluster_domain = var.cluster_domain
  path           = var.flux_bootstrap_git_path
}

locals {
  k8s_service_capture = regex("^https?://([^:@/?#]+)(:([0-9]+))?$", var.cluster_endpoint)
  k8s_service_host    = local.k8s_service_capture[0]
  k8s_service_port    = local.k8s_service_capture[2] != null ? local.k8s_service_capture[2] : 443
}

resource "helm_release" "cilium" {
  chart      = "cilium"
  name       = "cilium"
  namespace  = "kube-system"
  repository = "https://helm.cilium.io"
  version    = var.pinned_version.cilium

  values = concat(
    [
      file("${path.module}/../../../manifest/cilium.yaml"),
      yamlencode({
        cluster = {
          name = var.cluster_name
        }
        hubble = {
          peerService = {
            clusterDomain = var.cluster_domain
          }
        }
        k8sServiceHost = local.k8s_service_host
        k8sServicePort = local.k8s_service_port
      })
    ],
    var.addon_override.cilium
  )
}

resource "helm_release" "kubelet_csr_approver" {
  chart      = "kubelet-csr-approver"
  name       = "kubelet-csr-approver"
  namespace  = "kube-system"
  repository = "https://postfinance.github.io/kubelet-csr-approver"
  version    = var.pinned_version.kubelet_csr_approver

  values = concat(
    [
      yamlencode({
        bypassDnsResolution = true
        replicas            = 1
      })
    ],
    var.addon_override.kubelet_csr_approver
  )
}

resource "flux_bootstrap_git" "fleet" {
  depends_on = [helm_release.cilium, helm_release.kubelet_csr_approver]

  cluster_domain = var.cluster_domain
  path           = var.addon_override.flux.watch_path
}

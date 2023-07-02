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
  version    = "1.14.0-rc.0"

  values = concat(
    [
      file("${path.module}/../../../manifest/cilium.yaml"),
      yamlencode({
        cluster = {
          name = var.cluster_name
        }
        hubble = {
          peerService = {
            clusterDomain = var.cluster_dns_domain
          }
        }
        k8sServiceHost = local.k8s_service_host
        k8sServicePort = local.k8s_service_port
      })
    ],
    var.cilium_override
  )
}

resource "helm_release" "kubelet_csr_approver" {
  chart      = "kubelet-csr-approver"
  name       = "kubelet-csr-approver"
  namespace  = "kube-system"
  repository = "https://postfinance.github.io/kubelet-csr-approver"
  version    = "1.0.1"

  values = [
    yamlencode({
      bypassDnsResolution = true
      replicas            = 1
    })
  ]
}

resource "flux_bootstrap_git" "fleet" {
  depends_on = [helm_release.cilium, helm_release.kubelet_csr_approver]

  cluster_domain = var.cluster_dns_domain
  path           = var.flux_git_repo_path
}

with import <nixpkgs> {config.allowUnfree = true;}; let
  base = [
    bat
    golangci-lint
    ruff
    rust-analyzer
    yq-go
  ];
  blog = [zola];
  devops = [
    _1password
    age
    cilium-cli
    cue
    fluxcd
    hubble
    istioctl
    kubectl
    kubernetes-helm
    kubescape
    kubie
    nerdctl
    nickel
    pulumi
    rage
    sops
    talosctl
    terraform
    tflint
    tfsec
    topiary
    weave-gitops
  ];
  nix = [alejandra];
  list = base ++ blog ++ devops ++ nix;
in
  list

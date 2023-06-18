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
    cilium-cli
    cue
    doppler
    fluxcd
    hubble
    istioctl
    kubectl
    kubernetes-helm
    kubescape
    kubeseal
    kubie
    nerdctl
    nickel
    pulumi
    talosctl
    terraform
    tflint
    tfsec
    topiary
  ];
  nix = [alejandra];
  list = base ++ blog ++ devops ++ nix;
in
  list

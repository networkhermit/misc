with import <nixpkgs> {}; let
  base = [
    bat
    golangci-lint
    ruff
    rust-analyzer
    yq-go
  ];
  blog = [zola];
  devops = [
    cue
    fluxcd
    kubectl
    kubernetes-helm
    kubie
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

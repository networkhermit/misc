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
    talosctl
    terraform
  ];
  nix = [alejandra];
  list = base ++ blog ++ devops ++ nix;
in
  list

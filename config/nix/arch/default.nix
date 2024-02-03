with import <nixpkgs> {config.allowUnfree = true;}; let
  base = [
    #lua-language-server
    #neovim
    #pwru
    #stylua
    #uutils-coreutils
    biome
    golangci-lint
  ];
  blog = [
    #zola
  ];
  devops = [
    #age
    #cilium-cli
    #cue
    #fluxcd
    #hyperfine
    #kubectl
    #kubernetes-helm (helm)
    #kubie
    #nerdctl
    #nickel
    #rage (rage-encryption)
    #sops
    #sqlfluff
    #tailscale
    #tailspin
    #talosctl
    #trivy
    _1password
    conftest
    hubble
    istioctl
    kubebuilder
    kubescape
    open-policy-agent
    opentofu
    terraform-ls
    tflint
  ];
  nix = [alejandra];
  list = base ++ blog ++ devops ++ nix;
in
  list

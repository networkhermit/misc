with import <nixpkgs> {config.allowUnfree = true;}; let
  base = [
    #lua-language-server
    #stylua
    golangci-lint
    rome
  ];
  blog = [
    #zola
  ];
  devops = [
    #age
    #cilium-cli
    #cue
    #kubectl
    #kubernetes-helm (helm)
    #kubie
    #nerdctl
    #nickel
    #pulumi
    #rage (rust-rage)
    #sops
    _1password
    conftest
    fluxcd
    hubble
    istioctl
    kubescape
    open-policy-agent
    opentofu
    talosctl
    terraform-ls
    tflint
    tfsec
    topiary
    weave-gitops
  ];
  nix = [alejandra];
  list = base ++ blog ++ devops ++ nix;
in
  list

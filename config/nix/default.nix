let
  pkgs = import <nixpkgs> {
    config = {
      allowUnfreePredicate =
        pkg:
        builtins.elem (pkgs.lib.getName pkg) [
          "1password-cli"
        ];
    };
    overlays = [ ];
  };
  osReleaseID =
    { }:
    let
      regexCapture =
        re: s:
        with builtins;
        let
          caps = match re s;
          matched = isList caps;
        in
        {
          inherit matched;
          cap = if matched then head caps else null;
        };
      readFileLines = path: with builtins; filter isString (split "\n" (readFile path));
      trimQuote =
        s:
        with regexCapture "\"(.*)\"" s;
        if matched then cap else with regexCapture "'(.*)'" s; if matched then cap else s;
    in
    builtins.foldl' (
      acc: elem: with regexCapture "ID=(.*)" elem; if matched then trimQuote cap else acc
    ) "linux" (readFileLines /etc/os-release);
in
if
  with builtins;
  elem currentSystem [
    "x86_64-linux"
    "aarch64-linux"
  ]
then
  let
    distro = osReleaseID { };
  in
  if distro == "arch" then
    with pkgs;
    let
      base = [
        #lua-language-server
        #stylua
        biome
        golangci-lint
      ];
      blog = [
        #zola
      ];
      devops = [
        #age
        #cue
        #fluxcd
        #k9s
        #kubectl
        #kubernetes-helm (helm)
        #kubie
        #nerdctl
        #nickel
        #open-policy-agent
        #opentofu
        #rage (rage-encryption)
        #sops
        #sqlfluff
        #talosctl
        _1password-cli
        conftest
        fnm
        kubescape
        terraform-ls
        tflint
      ];
      nix = [
        nix-tree
        nixd
        nixfmt-rfc-style
      ];
    in
    base ++ blog ++ devops ++ nix
  else if distro == "kali" then
    with pkgs;
    let
      base = [
        pwru
        yq-go
      ];
      nix = [
        nix-tree
        nixfmt-rfc-style
      ];
    in
    base ++ nix
  else
    abort "✗ unknown distro: ‘${distro}’"
else if builtins.currentSystem == "aarch64-darwin" then
  with pkgs;
  let
    base = [
      #curl
      #git
      #lsof
      #man
      #openssh
      #rsync
      #vim
      #zsh
      b3sum
      bash-completion
      bashInteractive
      bat
      black
      cargo
      clippy
      cmatrix
      cowsay
      delve
      eza
      fd
      #fish
      fortune
      fzf
      go
      go-tools
      golangci-lint
      gopls
      gotools
      hexyl
      htop
      hyperfine
      jq
      ldns
      lua-language-server
      mold
      moreutils
      mypy
      neovim
      python3
      python312Packages.pip
      ripgrep
      ruff
      rust-analyzer
      rust.packages.stable.rustPlatform.rustcSrc
      rustc
      rustfmt
      sccache
      shellcheck
      sl
      stylua
      tailspin
      tmux
      tree
      uutils-coreutils
      watch
      yq-go
      zsh-autosuggestions
      zsh-syntax-highlighting
    ];
    devops = [
      _1password-cli
      actionlint
      awscli2
      biome
      fnm
      mitmproxy
      nmap
      opentofu
      python312Packages.cfn-lint
      sops
      steampipe
      terraform-ls
      tflint
    ];
    nix = [
      nix-tree
      nixd
      nixfmt-rfc-style
    ];
  in
  base ++ devops ++ nix
else
  abort "✗ unknown os: ‘${builtins.currentSystem}’"

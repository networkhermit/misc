let
  pkgs = import <nixpkgs> {
    config = {
      allowUnfreePredicate = pkg:
        builtins.elem (pkgs.lib.getName pkg) [
          "1password-cli"
        ];
    };
    overlays = [];
  };
  osReleaseID = {}: let
    regexCapture = re: s:
      with builtins; let
        caps = match re s;
        matched = isList caps;
      in {
        inherit matched;
        cap =
          if matched
          then head caps
          else null;
      };
    readFileLines = path: with builtins; filter isString (split "\n" (readFile path));
    trimQuote = s:
      with regexCapture "\"(.*)\"" s;
        if matched
        then cap
        else
          with regexCapture "'(.*)'" s;
            if matched
            then cap
            else s;
  in
    builtins.foldl' (acc: elem:
      with regexCapture "ID=(.*)" elem;
        if matched
        then trimQuote cap
        else acc) "linux"
    (readFileLines
      /etc/os-release);
in
  if with builtins; elem currentSystem ["x86_64-linux" "aarch64-linux" "x86_64-freebsd"]
  then let
    distro = osReleaseID {};
  in
    if distro == "alpine"
    then
      with pkgs; let
        base = [
          #neovim
          #stylua
          #uutils-coreutils
        ];
        blog = [
          #zola
        ];
        devops = [
          #age
          #cue (cue-cli)
          #hyperfine
          #k9s
          #kubectl
          #kubernetes-helm (helm)
          #nerdctl
          #nickel
          #opentofu
          #sops
          #tailscale
          #tflint
        ];
      in
        base ++ blog ++ devops
    else if builtins.elem distro ["arch" "archarm" "artix"]
    then
      with pkgs; let
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
        dev = [
          corepack_20
          nodejs_20
        ];
        devops = [
          #age
          #cilium-cli
          #cue
          #fluxcd
          #hyperfine
          #istioctl (istio)
          #k9s
          #kubectl
          #kubernetes-helm (helm)
          #kubie
          #nerdctl
          #nickel
          #opentofu
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
          kubebuilder
          kubescape
          terraform-ls
          tflint
        ];
        nix = [
          alejandra
          nix-tree
        ];
      in
        base ++ blog ++ dev ++ devops ++ nix
    else if distro == "fedora"
    then
      with pkgs; let
        base = [
          #neovim
        ];
        blog = [
        ];
        devops = [
          #age
          #hyperfine
          #kubectl (kubernetes-client)
          #kubernetes-helm (helm)
          #open-policy-agent
          #opentofu
          #trivy
        ];
      in
        base ++ blog ++ devops
    else if distro == "gentoo"
    then
      with pkgs; let
        base = [
          #app-editors/neovim
        ];
        blog = [
        ];
        devops = [
          #net-vpn/tailscale
        ];
      in
        base ++ blog ++ devops
    else if distro == "kali"
    then
      with pkgs; let
        base = [
          #neovim
          #uutils-coreutils (rust-coreutils)
          biome
          go-tools
          golangci-lint
          lua-language-server
          pwru
          ruff
          rust-analyzer
          stylua
          yq-go
        ];
        blog = [
          zola
        ];
        devops = [
          #age
          #cilium-cli
          #hubble
          #hyperfine
          #kubernetes-helm
          #tailspin
          #tetragon
          #trivy
          _1password
          conftest
          cue
          fluxcd
          istioctl
          k9s
          kubebuilder
          kubectl
          kubescape
          kubie
          nerdctl
          nickel
          opentofu
          rage
          sops
          sqlfluff
          talosctl
          terraform-ls
          tflint
        ];
        nix = [
          alejandra
          nix-tree
        ];
      in
        base ++ blog ++ devops ++ nix
    else if distro == "void"
    then
      with pkgs; let
        base = [
          #lua-language-server
          #neovim
          #pwru
          #stylua (StyLua)
        ];
        blog = [
          #zola
        ];
        devops = [
          #age
          #hyperfine
          #k9s
          #kubectl
          #kubernetes-helm
          #nerdctl
          #sops
          #tailscale
          #terraform-ls
          #tflint
        ];
      in
        base ++ blog ++ devops
    else if distro == "freebsd"
    then
      with pkgs; let
        base = [
          #neovim
          #stylua
          #uutils-coreutils (rust-coreutils)
        ];
        blog = [
          #zola
        ];
        devops = [
          #_1password (1password-client2)
          #age
          #hyperfine
          #k9s
          #kubectl
          #kubernetes-helm (helm)
          #opentofu
          #rage (rage-encryption)
          #sops
          #tailscale
          #tailspin
          #tflint
          #trivy
        ];
      in
        base ++ blog ++ devops
    else abort "✗ unknown distro: ‘${distro}’"
  else if builtins.currentSystem == "x86_64-openbsd"
  then
    with pkgs; let
      base = [
        #colordiff--
        #colorls--
        #libb64 (base64--)
        #neovim--
        #watch (gnuwatch--)
      ];
      blog = [
        #zola--
      ];
      devops = [
        #age--
        #hyperfine--
        #kubectl--
        #sops--
        #tailscale--
        #tflint--
      ];
    in
      base ++ blog ++ devops
  else if builtins.currentSystem == "aarch64-darwin"
  then
    with pkgs; let
      base = [
        #curl
        #git
        #lsof
        #man
        #openssh
        #rsync
        #vim
        #zsh
        ansible
        ansible-lint
        b3sum
        bash-completion
        bashInteractive
        bat
        biome
        black
        cargo
        cargo-audit
        cargo-outdated
        clippy
        cmatrix
        cowsay
        delve
        eza
        fd
        fish
        fortune
        fzf
        go
        go-tools
        golangci-lint
        gopls
        hexyl
        htop
        jq
        ldns
        lua-language-server
        mold
        moreutils
        mypy
        neovim
        python3
        python312Packages.argcomplete
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
        tmux
        tree
        uutils-coreutils
        watch
        yamllint
        yq-go
        zsh-autosuggestions
        zsh-syntax-highlighting
      ];
      devops = [
        #awscli2
        _1password
        actionlint
        gh
        hyperfine
        k9s
        kubebuilder
        kubectl
        kubernetes-helm
        kubie
        mitmproxy
        nmap
        opentofu
        python312Packages.cfn-lint
        rain
        sops
        sqlfluff
        steampipe
        tailspin
        terraform-ls
        testssl
        tflint
        trivy
      ];
      nix = [
        alejandra
        nix-tree
      ];
    in
      base ++ devops ++ nix
  else abort "✗ unknown os: ‘${builtins.currentSystem}’"

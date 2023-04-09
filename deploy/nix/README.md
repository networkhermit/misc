```bash
nix-channel --add https://nixos.org/channels/nixpkgs-unstable

nix-channel --update
nix-env --install --remove-all --file default.nix
nix-collect-garbage --delete-old

nix-env --query | sort
```

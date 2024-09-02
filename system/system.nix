{ stateVersion }: {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.substituters = [ "https://cosmic.cachix.org/" "https://nixcache.reflex-frp.org" ];
  nix.settings.trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=" ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = stateVersion;
}

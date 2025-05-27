{ codeFontName, flavor, pkgs, ... }: {
  imports = [
    (import ./emacs-config.nix { inherit codeFontName; inherit flavor; })
    ./emacs-init.nix
    ./emacs-package.nix
  ];
  programs.emacs = {
    enable  = true;
    # package = pkgs.emacs30;
  };
  programs.ripgrep.enable = true;
}

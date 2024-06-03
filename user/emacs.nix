{ pkgs, ... }: {
  imports = [
    ./emacs-config.nix
    ./emacs-init.nix
    ./emacs-package.nix
  ];
  home.packages = [ pkgs.ripgrep ];
  programs.emacs.enable = true;
}

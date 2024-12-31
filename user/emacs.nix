{ pkgs, ... }: {
  imports = [
    ./emacs-config.nix
    ./emacs-init.nix
    ./emacs-package.nix
  ];
  programs.emacs.enable = true;
  programs.ripgrep.enable = true;
}

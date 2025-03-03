{ pkgs, ... }: {
  imports = [
    ./emacs-config.nix
    ./emacs-init.nix
    ./emacs-package.nix
  ];
  programs.emacs = {
    enable = true;
    package = pkgs.emacs30;
  };
  programs.ripgrep.enable = true;
}

{ inputs, pkgs, ... }: {
  imports = [
    inputs.ags.homeManagerModules.default
  ];
  home.packages = with pkgs; [
    hyprcursor
    hyprpicker
    sassc
  ];
  programs.ags = {
    configDir = ./ags;
    enable = true;
    extraPackages = with pkgs; [
      accountsservice
      gtksourceview
      webkitgtk
    ];
  };
}

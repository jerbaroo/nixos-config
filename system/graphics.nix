{ inputs, pkgs, system, ... }:
let
  wallpaper = pkgs.fetchurl {
    hash = "sha256-8FaX9qSTZ9Nw12IGwRKPwB1s765dQ/sTPImx6jN4BXE=";
    url = "https://raw.githubusercontent.com/vinceliuice/Orchis-theme/master/wallpaper/4k.jpg";
  };
in
{
  console = {
    colors = [
      "1e1e2e"
      "181825"
      "313244"
      "45475a"
      "585b70"
      "cdd6f4"
      "f5e0dc"
      "b4befe"
      "f38ba8"
      "fab387"
      "f9e2af"
      "a6e3a1"
      "94e2d5"
      "89b4fa"
      "cba6f7"
      "f2cdcd"
    ];
    earlySetup = true;
  };
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
  };
  programs.hyprland.enable = true;
}

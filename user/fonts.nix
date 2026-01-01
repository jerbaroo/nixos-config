{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;

  gtk.font = {
    name = "Atkinson Hyperlegible";
    package = pkgs.atkinson-hyperlegible;
    size = 10;
  };

  home.packages = with pkgs; [
    cascadia-code
    nerd-fonts.iosevka
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    noto-fonts
  ];
}

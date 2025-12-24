{ accent, flavor, lib, pkgs, ... }:
{
  home.file.".config/helix/themes/theme.toml".text = ''
    inherits = "catppuccin-${flavor}"
    "ui.background" = {}
    "ui.help" = { fg = "text", bg = "base" }
    "ui.menu" = { fg = "text", bg = "base" }
    "ui.popup" = { fg = "${accent}", bg = "base" }
    "comment" = { fg = "${accent}" }
  '';
  programs.helix = {
    defaultEditor = true;
    enable = true;
    settings = {
      theme = lib.mkForce "theme";
    };
  };
}

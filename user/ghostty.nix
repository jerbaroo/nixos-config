{
  codeFontName,
  color-schemes,
  config,
  flavor,
  pkgs,
  system,
  wrapGL,
  ...
}:
{
  programs.ghostty = {
    enable = true;
    package = (if wrapGL then config.lib.nixGL.wrap else (x: x)) pkgs.ghostty;
    settings = {
      background-opacity = 0.7;
      command = "${pkgs.fish}/bin/fish";
      config-file = [
        (color-schemes + "/ghostty/Catppuccin Mocha") # TODO flavor
      ];
      confirm-close-surface = false;
      font-family = codeFontName;
      font-size = 20;
      scrollback-limit = 1000000;
    };
  };
}

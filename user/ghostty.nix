{
  codeFontName,
  flavor,
  inputs,
  pkgs,
  system,
  ...
}:
{
  programs.ghostty = {
    enable = true;
    settings = {
      background-opacity = 0.7;
      command = "${pkgs.fish}/bin/fish";
      config-file = [
        (inputs.color-schemes + "/ghostty/catppuccin-${flavor}")
      ];
      confirm-close-surface = false;
      font-family = codeFontName;
      font-size = 26;
      scrollback-limit = 1000000;
    };
  };
}

{
  codeBackgroundOpacity,
  codeFontName,
  codeFontSize,
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
      background-opacity = codeBackgroundOpacity;
      command = "${pkgs.tmux}/bin/tmux attach -t main || ${pkgs.tmux}/bin/tmux new -s main";
      config-file = [
        "${color-schemes}/ghostty/Catppuccin ${pkgs.lib.strings.toSentenceCase flavor}"
      ];
      confirm-close-surface = false;
      font-family = codeFontName;
      font-size = codeFontSize;
      scrollback-limit = 1000000000;
    };
  };
}

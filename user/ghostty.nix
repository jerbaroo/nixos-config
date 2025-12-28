{
  accent,
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
let
  neo-safe = pkgs.writeScriptBin "neo-safe" ''
  #!/usr/bin/env fish
  trap "" INT
  ${pkgs.neo}/bin/neo -D -f 120 -F -c ${accent}
  exec ${pkgs.fish}/bin/fish
'';
  start-tmux = pkgs.writeScriptBin "start-tmux" ''
    #!/usr/bin/env fish
    ${pkgs.tmux}/bin/tmux new-session -A -s main "${neo-safe}/bin/neo-safe"
'';
in {
  programs.ghostty = {
    enable = true;
    package = (if wrapGL then config.lib.nixGL.wrap else (x: x)) pkgs.ghostty;
    settings = {
      background-opacity = codeBackgroundOpacity;
      command = "${start-tmux}/bin/start-tmux";
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

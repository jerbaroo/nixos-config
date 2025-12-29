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
      keys.normal = {
        "C-h" = "jump_view_left";
        "C-j" = "jump_view_down";
        "C-k" = "jump_view_up";
        "C-l" = "jump_view_right";
        space = {
          space = "file_picker";
          "." = [
            ":sh rm -f /tmp/unique-file"
            ":insert-output ${pkgs.yazi}/bin/yazi %{buffer_name} --chooser-file=/tmp/unique-file"
            ":insert-output echo '\x1b[?1049h\x1b[?2004h' > /dev/tty"
            ":open %sh{cat /tmp/unique-file}"
            ":redraw"
          ];
          ":" = "command_palette";
          b = {
            b = "buffer_picker";
            k = ":buffer-close";
            n = ":buffer-next";
            N = ":new";
            p = ":buffer-previous";
          };
          c = {
            c = "toggle_comments";
            d = "diagnostics_picker";
            r = "rename_symbol";
          };
          g = {
            g = [
              ":write-all"
              ":new"
              ":insert-output ${pkgs.lazygit}/bin/lazygit"
              ":set mouse false" # First disable mouse to hint helix into activating it
              ":set mouse true"
              ":buffer-close!"
              ":redraw"
              ":reload-all"
            ];
          };
          l = {
            r = ":lsp-restart";
            s = ":lsp-stop";
          };
          r = ":config-reload";
        };
      };
      theme = lib.mkForce "theme";
    };
  };
}

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
          "." = "file_explorer_in_current_buffer_directory";
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
            g = ":run-shell-command tmux display-popup -d \"$PWD\" -w '100%%' -h '100%%' lazygit";
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

{ inputs, pkgs, system, ... }: {
  programs.ghostty = {
    enable = true;
    settings = {
      command = "${pkgs.fish}/bin/fish";
      config-file = [
        (inputs.color-schemes + "/ghostty/catppuccin-mocha")
      ];
      confirm-close-surface = false;
      font-family = "JetBrainsMono Nerd Font";
      font-size = 22;
      scrollback-limit = 1000000;
      window-decoration = false;
    };
  };
}

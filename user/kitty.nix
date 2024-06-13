{ pkgs, ... }: {
  programs.kitty = {
    enable = true;
    font.size = 22;
    font.name = "JetBrainsMono";
    font.package = pkgs.jetbrains-mono;
    settings = {
      confirm_os_window_close = 0;
      clipboard_control = "clipboard_control write-clipboard write-primary read-clipboard-ask read-primary-ask no_append";
      enable_audio_bell = false;
      hide_window_decorations = false;
      shell = "${pkgs.fish}/bin/fish";
      update_check_interval = 0;
    };
  };
}

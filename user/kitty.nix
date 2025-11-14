{
  codeBackgroundOpacity,
  codeFontName,
  config,
  pkgs,
  wrapGL,
  ...
}:
{
  programs.kitty = {
    enable = true;
    font.size = 18;
    font.name = codeFontName;
    package = (if wrapGL then config.lib.nixGL.wrap else (x: x)) pkgs.kitty;
    settings = {
      background_opacity = codeBackgroundOpacity;
      confirm_os_window_close = 0;
      clipboard_control = "clipboard_control write-clipboard write-primary read-clipboard-ask read-primary-ask no_append";
      enable_audio_bell = false;
      hide_window_decorations = false;
      shell = "${pkgs.fish}/bin/fish";
      update_check_interval = 0;
    };
  };
}

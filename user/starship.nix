{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      character = {
        error_symbol = "[❯](bold red)";
        success_symbol = "[❯](bold green)";
        vimcmd_symbol = "[❮](bold green)";
        vimcmd_replace_symbol = "[❮](bold purple)";
        vimcmd_replace_one_symbol = "[❮](bold purple)";
        vimcmd_visual_symbol = "[❮](bold yellow)";
      };
      # package.disabled = true;
    };
  };
}

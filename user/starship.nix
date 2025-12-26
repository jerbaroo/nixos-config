{
  programs.starship = {
    enable = true;
    enableTransience = true;
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
      gcloud.format = "$symbol";
      gcloud.symbol = "☁️ "; # To avoid extra space after default symbol.
      haskell.format = "[$symbol($version )]($style)";
      nix_shell.format = "$symbol";
      nix_shell.symbol = "❄️ "; # To avoid extra space after default symbol.
      python.format = "$symbol";
    };
  };
}

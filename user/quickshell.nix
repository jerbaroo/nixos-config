{ pkgs, ... }:
{
  # fonts.fontconfig.enable = true;
  # home.packages = with pkgs; [
  #   cascadia-code
  #   nerd-fonts.jetbrains-mono
  #   nerd-fonts.symbols-only
  # ];
  programs.quickshell = {
    enable = true;
  };
}

{ pkgs, ... }:
{
  # Required to avoid '[bat warning]: Unknown theme' when using delta.
  # But bat is also just great.
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batgrep
      batman
      batpipe
      batwatch
      prettybat
    ];
  };
  programs.git = {
    delta = {
      enable = true;
      options.line-numbers = true;
    };
    enable = true;
    extraConfig = {
      push.autoSetupRemote = true;
      rebase.autoSquash = true;
    };
    userName = "jerbaroo";
    userEmail = "jerbaroo.work@pm.me";
  };
  programs.git-cliff.enable = true;
}

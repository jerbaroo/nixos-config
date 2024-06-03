{ pkgs, ... }: {
  home.packages = with pkgs; [
    nerdfonts # Required for lsd (and others probably).
  ];
  fonts.fontconfig.enable = true;
}

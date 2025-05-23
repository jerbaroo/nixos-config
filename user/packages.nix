{ pkgs, ... }: {
  home.packages = with pkgs; [
    android-tools
    blueman
    feh
    jq
    libreoffice
    obs-studio
    pavucontrol
    rustmission
    texliveFull
    vlc
    zoom-us
  ];
}

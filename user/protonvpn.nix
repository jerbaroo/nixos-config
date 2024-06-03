{ pkgs, ... }: {
  home.packages = [ pkgs.protonvpn-gui ];
  services.network-manager-applet.enable = true; # Required by ProtonVPN.
}

{ inputs, pkgs, system, ... }: {
  programs.hyprland.enable = true;
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };
}

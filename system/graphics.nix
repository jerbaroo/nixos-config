{ inputs, system, ... }: {
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };
  programs.hyprland = {
    enable = true;
    # package = inputs.hyprland.packages.${system}.hyprland;
  };
}

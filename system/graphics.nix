{
  inputs,
  pkgs,
  system,
  ...
}:
{
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${system}.hyprland;
  };
  # services.desktopManager.cosmic.enable = true;
  # services.displayManager.cosmic-greeter.enable = true;
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };
}

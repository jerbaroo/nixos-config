{
  config,
  inputs,
  pkgs,
  pkgs-unstable,
  system,
  ...
}:

let
  accent = "yellow";
  codeFontName = "JetBrainsMono Nerd Font";
  flavor = "mocha";
  hostname = "nixos";
  palette =
    (pkgs.lib.importJSON (config.catppuccin.sources.palette + "/palette.json")).${flavor}.colors;
  stateVersion = "24.05";
  username = "jer";
in
{
  imports = [
    ./system/boot.nix
    ./system/docker.nix
    (import ./system/graphics.nix {
      inherit inputs;
      inherit pkgs;
      inherit system;
    })
    ./system/hardware-configuration.nix
    ./system/keyboard.nix
    ./system/llm.nix
    ./system/locale.nix
    (import ./system/network.nix { inherit hostname; })
    ./system/openrgb.nix
    ./system/printing.nix
    ./system/sound.nix
    ./system/steam.nix
    ./system/store.nix
    (import ./system/system.nix { inherit stateVersion; })
    (import ./system/theme.nix {
      inherit accent;
      inherit flavor;
    })
    ./system/transmission.nix
    (import ./system/user.nix {
      # TODO: do we need to pass accent and flavor if they are set in config.catppuccin?
      inherit accent;
      inherit codeFontName;
      inherit config;
      inherit flavor;
      inherit hostname;
      inherit inputs;
      inherit palette;
      inherit pkgs;
      inherit pkgs-unstable;
      inherit stateVersion;
      inherit system;
      inherit username;
    })
  ];
  programs.adb.enable = true;
}

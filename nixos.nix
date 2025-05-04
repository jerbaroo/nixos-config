{ config, inputs, pkgs, pkgs-unstable, system, ... }:

let
  accent = "yellow";
  flavor = "mocha";
  hostname = "nixos";
  stateVersion = "24.05";
  username = "jer";
in {
  imports =
    [ ./system/boot.nix
      ./system/docker.nix
      (import ./system/graphics.nix { inherit inputs; inherit pkgs; inherit system; })
      ./system/hardware-configuration.nix
      ./system/keyboard.nix
      ./system/locale.nix
      (import ./system/network.nix { inherit hostname; })
      ./system/openrgb.nix
      ./system/printing.nix
      ./system/sound.nix
      ./system/store.nix
      (import ./system/system.nix { inherit stateVersion; })
      (import ./system/theme.nix { inherit accent; inherit flavor; })
      (import ./system/user.nix {
        inherit accent;
        inherit config;
        inherit flavor;
        inherit hostname;
        inherit inputs;
        inherit pkgs;
        inherit pkgs-unstable;
        inherit stateVersion;
        inherit system;
        inherit username;
      })
    ];
}

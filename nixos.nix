{
  accent,
  config,
  flavor,
  hyprland,
  pkgs,
  pkgs-unstable,
  stateVersion,
  system,
  username,
  ...
}: {
  home-manager = {
    backupFileExtension = ".backup";
    extraSpecialArgs = {
      inherit accent;
      inherit codeFontName;
      inherit flavor;
      inherit pkgs-unstable;
      inherit stateVersion;
      inherit system;
      inherit username;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = import ./user/home.nix;
  };
  imports = [
    ./system/boot.nix
    ./system/docker.nix
    (import ./system/graphics.nix {
      inherit hyprland;
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
  ];
  programs.adb.enable = true; # TODO
  users.users.${username} = {
    extraGroups = [
      "adbusers"
      "docker"
      "kvm"
      "networkmanager"
      "wheel"
    ];
    isNormalUser = true;
  };
}

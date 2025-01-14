{ accent, config, flavor, inputs, pkgs-unstable, stateVersion, pkgs, system, username, ... }: {
  home-manager = {
    backupFileExtension = ".backup";
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = {
      imports = [
        inputs.catppuccin.homeManagerModules.catppuccin

        ../user/apps.nix
        (import ../user/ignis.nix { inherit inputs; inherit pkgs; inherit system; })
        ../user/direnv.nix
        ../user/emacs.nix
        ../user/fish.nix
        ../user/fonts.nix
        (import ../user/firefox.nix { inherit username; })
        ../user/git.nix
        (import ../user/ghostty.nix { inherit inputs; inherit pkgs; inherit system; })
        (import ../user/hyprland.nix { inherit inputs; inherit pkgs; inherit system; })
        ../user/kitty.nix
        ../user/lsd.nix
        (import ../user/neovim.nix { inherit pkgs; inherit pkgs-unstable; })
        ../user/protonvpn.nix
        ../user/starship.nix
        ../user/tex.nix
        (import ../user/theme.nix { inherit accent; inherit flavor; inherit pkgs; })
        ../user/tmux.nix
      ];
      home.stateVersion = stateVersion;
    };
  };

  users.users.${username} = {
    extraGroups = [ "docker" "networkmanager" "wheel" ];
    isNormalUser = true;
  };
}

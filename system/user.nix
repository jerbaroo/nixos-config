{ accent, codeFontName, config, flavor, inputs, palette, pkgs, pkgs-unstable, stateVersion, system, username, ... }: {
  home-manager = {
    backupFileExtension = ".backup";
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = {
      imports = [
        inputs.catppuccin.homeModules.catppuccin

        # TODO better way to pass args to modules.
        ../user/apps.nix
        (import ../user/browser.nix { inherit username; })
        (import ../user/ignis.nix { inherit inputs; inherit palette; inherit pkgs; inherit system; })
        ../user/direnv.nix
        (import ../user/emacs.nix { inherit codeFontName; inherit flavor; inherit pkgs; })
        ../user/fish.nix
        ../user/fonts.nix
        ../user/git.nix
        (import ../user/ghostty.nix { inherit codeFontName; inherit flavor; inherit inputs; inherit pkgs; inherit system; })
        (import ../user/hyprland.nix { inherit accent; inherit flavor; inherit inputs; inherit pkgs; inherit system; })
        (import ../user/kitty.nix { inherit codeFontName; inherit pkgs; })
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

{
  description = "NixOS";
  inputs = {
    catppuccin.url = "github:catppuccin/nix";
    color-schemes = {
      url = "github:mbadolato/iTerm2-Color-Schemes";
      flake = false;
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-25.05";
    };
    ignis.url = "github:linkfrg/ignis";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      inputs.hyprland.follows = "hyprland";
      url = "github:hyprwm/hyprland-plugins";
    };
    hyprsplit = {
      url = "github:shezdy/hyprsplit";
      inputs.hyprland.follows = "hyprland";
    };
    hyprtasking = {
      url = "github:raybbian/hyprtasking";
      inputs.hyprland.follows = "hyprland";
    };
    nixgl.url = "github:nix-community/nixGL";
    nixos-cosmic = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:lilyinstarlight/nixos-cosmic";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs =
    inputs:
    let
      accent = "yellow";
      allowUnfree = true;
      codeFontName = "JetBrainsMono Nerd Font";
      flavor = "mocha";
      hostname = "nixos";
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [ inputs.nixgl.overlay ];
      };
      pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
      stateVersion = "24.05";
      system = "x86_64-linux";
      username = "jer";
    in
    {
      nixosConfigurations = {
        ${hostname} = inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./system/nixos.nix
            inputs.catppuccin.nixosModules.catppuccin
            inputs.home-manager.nixosModules.home-manager
            inputs.nixos-cosmic.nixosModules.default
          ];
          specialArgs = {
            inherit accent;
            inherit allowUnfree;
            inherit codeFontName;
            inherit flavor;
            inherit pkgs-unstable;
            inherit stateVersion;
            inherit system;
            inherit username;
            hyprland = inputs.hyprland;
          };
        };
      };
      homeConfigurations = {
        "${username}@${hostname}" = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit accent;
            inherit allowUnfree;
            inherit codeFontName;
            inherit flavor;
            inherit pkgs-unstable;
            inherit stateVersion;
            inherit system;
            inherit username;
            catppuccin = inputs.catppuccin;
            color-schemes = inputs.color-schemes;
            hyprland = inputs.hyprland;
            hyprsplit = inputs.hyprsplit;
            hyprtasking = inputs.hyprtasking;
            ignis = inputs.ignis;
            nixgl = inputs.nixgl;
            plugins = false;
            wrapGL = true;
          };
          modules = [ ./user/home.nix ];
        };
      };
    };
}

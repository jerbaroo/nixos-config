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
    hyprland = {
      url = "github:hyprwm/Hyprland";
    };
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
      pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
      hostname = "nixos";
      system = "x86_64-linux";
      username = "jer";
    in
    {
      nixosConfigurations = {
        ${hostname} = inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./nixos.nix
            inputs.catppuccin.nixosModules.catppuccin
            inputs.home-manager.nixosModules.home-manager
            inputs.nixos-cosmic.nixosModules.default
          ];
          specialArgs = {
            inherit inputs;
            inherit pkgs-unstable;
            inherit system;
          };
        };
      };
      homeConfigurations = {
        "${username}@${hostname}" = inputs.home-manager.lib.homeManagerConfiguration {
          modules = [ ./user/home.nix ];
        };
      };
    };
}

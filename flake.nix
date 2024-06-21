{
  description = "NixOS";

  inputs = {
    ags.url = "github:Aylur/ags";
    catppuccin.url = "github:catppuccin/nix";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-24.05";
    };
    hyprland = {
      inputs.nixpkgs.follows = "nixpkgs";
      submodules = true;
      type = "git";
      url = "https://github.com/hyprwm/Hyprland/";
    };
    hyprland-plugins = {
      inputs.hyprland.follows = "hyprland";
      url = "github:hyprwm/hyprland-plugins";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nur.url = "github:nix-community/NUR";
  };

  outputs = inputs@{ self, catppuccin, home-manager, nixpkgs, nur, ... }:
      let
        system = "x86_64-linux";
      in {
        nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
          modules = [
            ./nixos.nix
            catppuccin.nixosModules.catppuccin
            home-manager.nixosModules.home-manager
            nur.nixosModules.nur
          ];
          specialArgs = { inherit inputs; inherit system; };
          inherit system;
        };
      };
}

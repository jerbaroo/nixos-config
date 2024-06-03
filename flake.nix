{
  description = "NixOS";

  inputs = {
    ags.url = "github:Aylur/ags";
    catppuccin.url = "github:catppuccin/nix";
    home-manager = {
      inputs.nixpkgs.follows  = "nixpkgs";
      url = "github:nix-community/home-manager/release-24.05";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    matugen.url = "github:InioX/matugen?ref=v2.2.0";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nur.url = "github:nix-community/NUR";
  };

  outputs = inputs@{ self, catppuccin, nixpkgs, nur, home-manager, ... }:
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

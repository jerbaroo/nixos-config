{
  description = "NixOS";

  inputs = {
    ags.url = "github:Aylur/ags";
    catppuccin.url = "github:catppuccin/nix";
    color-schemes = {
      url = "github:mbadolato/iTerm2-Color-Schemes";
      flake = false;
    };
    ghostty.url = "github:ghostty-org/ghostty";
    ghostty-hm.url = "github:clo4/ghostty-hm-module";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-24.11";
    };
    hyprland = {
      inputs.nixpkgs.follows = "nixpkgs";
      # ref = "refs/tags/v0.41.0";
      submodules = true;
      type = "git";
      url = "https://github.com/hyprwm/Hyprland/";
    };
    hyprland-plugins = {
      inputs.hyprland.follows = "hyprland";
      url = "github:hyprwm/hyprland-plugins";
    };
    nixos-cosmic = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:lilyinstarlight/nixos-cosmic";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
  };

  outputs = inputs:
    let
      pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
      system = "x86_64-linux";
    in {
      nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./nixos.nix
          inputs.catppuccin.nixosModules.catppuccin
          # inputs.ghostty-hm.homeModules.default
          inputs.home-manager.nixosModules.home-manager
          inputs.nixos-cosmic.nixosModules.default
          inputs.nur.modules.nixos.default
          # inputs.nur.modules.homeManager.default
        ];
        specialArgs = { inherit inputs; inherit pkgs-unstable; inherit system; };
      };
    };
}

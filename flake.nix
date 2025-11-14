{
  description = "NixOS";
  inputs = {
    catppuccin = {
      # inputs.nixpkgs.follows = "home-manager";
      url = "github:catppuccin/nix";
    };
    color-schemes = {
      flake = false;
      url = "github:mbadolato/iTerm2-Color-Schemes";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/master";
    };
    ignis = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:linkfrg/ignis";
    };
    hyprland = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:hyprwm/Hyprland";
    };
    hyprland-plugins = {
      inputs.hyprland.follows = "hyprland";
      url = "github:hyprwm/hyprland-plugins";
    };
    hyprsplit = {
      inputs.hyprland.follows = "hyprland";
      url = "github:shezdy/hyprsplit";
    };
    hyprtasking = {
      inputs.hyprland.follows = "hyprland";
      url = "github:raybbian/hyprtasking";
    };
    niri.url = "github:sodiboo/niri-flake";
    nixgl.url = "github:nix-community/nixGL";
    nixos-cosmic = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:lilyinstarlight/nixos-cosmic";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
  };
  outputs =
    inputs:
    let
      accent = "pink";
      allowUnfree = false;
      codeFontName = "JetBrainsMono Nerd Font";
      flavor = "mocha";
      hostname = "nixos";
      overlays = [
          inputs.niri.overlays.niri
          inputs.nixgl.overlay
          inputs.nur.overlays.default
      ];
      pkgs = import inputs.nixpkgs {
        inherit overlays;
        inherit system;
      };
      stateVersion = "25.05";
      system = "x86_64-linux";
      username = "jeremy-barisch-rooney";
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
            inherit hostname;
            inherit stateVersion;
            inherit system;
            inherit username;
            catppuccin = inputs.catppuccin;
            color-schemes = inputs.color-schemes;
            genericLinux = true;
            hyprland = inputs.hyprland;
            hyprsplit = null;
            # hyprsplit = inputs.hyprsplit;
            hyprtasking = null;
            # hyprtasking = inputs.hyprtasking;
            ignis = inputs.ignis;
            niri = inputs.niri;
            nixgl = inputs.nixgl;
            plugins = true;
            systemPAM = true;
            wrapGL = true;
          };
          modules = [ ./user/home.nix ];
        };
      };
    };
}

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
    spicetify.url = "github:Gerg-L/spicetify-nix";
  };
  outputs =
    inputs:
    let
      accent = "pink";
      allowUnfreePredicate =
        let whitelist = map pkgs.lib.getName [ pkgs.spotify ];
        in  pkg: builtins.elem (pkgs.lib.getName pkg) whitelist;
      codeBackgroundOpacity = 0.7;
      codeFontName = "Iosevka Nerd Font Mono";
      codeFontSize = 11;
      flavor = "mocha";
      gap = 3;
      ghdashboardPort = 1234;
      hostname = "nixos";
      pkgs = import inputs.nixpkgs {
        overlays = [
            inputs.niri.overlays.niri
            inputs.nixgl.overlay
            inputs.nur.overlays.default
        ];
        inherit system;
      };
      stateVersion = "25.05";
      system = "x86_64-linux";
      temperature = 3000;
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
            inherit codeFontName;
            inherit codeFontSize;
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
            inherit allowUnfreePredicate;
            inherit codeBackgroundOpacity;
            inherit codeFontName;
            inherit codeFontSize;
            inherit flavor;
            inherit gap;
            inherit ghdashboardPort;
            inherit hostname;
            inherit stateVersion;
            inherit system;
            inherit temperature;
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
            spicetify = inputs.spicetify;
            systemPAM = true;
            wrapGL = true;
          };
          modules = [ ./user/home.nix ];
        };
      };
    };
}

{
  accent,
  allowUnfreePredicate,
  catppuccin,
  codeBackgroundOpacity,
  codeFontName,
  codeFontSize,
  color-schemes,
  config,
  flavor,
  gap,
  ghdashboardPort,
  hostname,
  hyprland,
  hyprsplit,
  hyprtasking,
  genericLinux,
  ignis,
  lib,
  niri,
  nixgl,
  pkgs,
  plugins,
  spicetify,
  stateVersion,
  system,
  systemPAM,
  temperature,
  username,
  wrapGL,
  ...
}:
let
  ignisPath = ".config/ignis/";
  palette =
    (pkgs.lib.importJSON (config.catppuccin.sources.palette + "/palette.json")).${flavor}.colors;
in
{
  imports = [
    catppuccin.homeModules.catppuccin
    ignis.homeManagerModules.default
    niri.homeModules.niri
    spicetify.homeManagerModules.default

    (import ./browser.nix { inherit ghdashboardPort; inherit pkgs; })
    ./direnv.nix
    (import ./emacs.nix {
      inherit codeFontName;
      inherit codeFontSize;
      inherit codeBackgroundOpacity;
      inherit flavor;
      inherit pkgs;
    })
    (import ./fish.nix { inherit hostname; inherit pkgs; inherit username; })
    ./fonts.nix
    (import ./ghostty.nix {
      inherit codeFontName;
      inherit codeFontSize;
      inherit codeBackgroundOpacity;
      inherit color-schemes;
      inherit config;
      inherit flavor;
      inherit pkgs;
      inherit system;
      inherit wrapGL;
    })
    ./git.nix
    (import ./helix.nix {
      inherit accent;
      inherit flavor;
      inherit lib;
      inherit pkgs;
    })
    (import ./hyprland.nix {
      inherit accent;
      inherit config;
      inherit flavor;
      inherit gap;
      inherit ghdashboardPort;
      inherit hyprland;
      inherit hyprsplit;
      inherit hyprtasking;
      inherit ignisPath;
      inherit palette;
      inherit pkgs;
      inherit plugins;
      inherit system;
      inherit systemPAM;
      inherit temperature;
      inherit username;
      inherit wrapGL;
    })
    (import ./ignis.nix {
      inherit accent;
      inherit ignis;
      inherit ignisPath;
      inherit palette;
      inherit pkgs;
    })
    (import ./kitty.nix {
      inherit codeBackgroundOpacity;
      inherit codeFontName;
      inherit codeFontSize;
      inherit config;
      inherit pkgs;
      inherit wrapGL;
    })
    ./lsd.nix
    (import ./neovim.nix {
      inherit pkgs;
    })
    ./niri.nix
    ./notifications.nix
    ./packages.nix
    ./quickshell.nix
    ./sound.nix
    (import ./spicetify.nix {
      inherit accent;
      inherit flavor;
      inherit palette;
      inherit pkgs;
      inherit spicetify;
    })
    ./starship.nix
    (import ./theme.nix {
      inherit accent;
      inherit flavor;
      inherit pkgs;
    })
    (import ./tmux.nix {
      inherit accent;
      inherit palette;
      inherit pkgs;
    })
    (import ./wlogout.nix {
      inherit accent;
      inherit palette;
      inherit pkgs;
    })
    (import ./zed.nix {
      inherit config;
      inherit pkgs;
      inherit wrapGL;
    })
  ];
  home = {
    homeDirectory = "/home/${username}";
    stateVersion = stateVersion;
    username = "${username}";
  };
  nixpkgs.config = {
    inherit allowUnfreePredicate;
  };
  programs.home-manager.enable = true;
  targets.genericLinux = {
    enable = genericLinux;
    nixGL = {
      defaultWrapper = "mesa";
      packages = nixgl.packages;
    };
  };
  xdg.configFile."environment.d/envvars.conf".text = ''
    PATH="$HOME/.config/emacs/bin:$HOME/.nix-profile/bin:$HOME/.cargo/bin:$PATH"
  '';
}

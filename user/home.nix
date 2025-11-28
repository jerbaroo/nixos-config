{
  accent,
  allowUnfreePredicate,
  catppuccin,
  codeFontName,
  codeFontSize,
  color-schemes,
  config,
  flavor,
  hostname,
  hyprland,
  hyprsplit,
  hyprtasking,
  genericLinux,
  ignis,
  niri,
  nixgl,
  pkgs,
  plugins,
  stateVersion,
  system,
  systemPAM,
  username,
  wrapGL,
  ...
}:
let
  codeBackgroundOpacity = 0.70;
  ghdashboardPort = 1234;
  palette =
    (pkgs.lib.importJSON (config.catppuccin.sources.palette + "/palette.json")).${flavor}.colors;
in
{
  imports = [
    catppuccin.homeModules.catppuccin
    ignis.homeManagerModules.default
    niri.homeModules.niri

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
    (import ./hyprland.nix {
      inherit accent;
      inherit config;
      inherit flavor;
      inherit ghdashboardPort;
      inherit hyprland;
      inherit hyprsplit;
      inherit hyprtasking;
      inherit palette;
      inherit pkgs;
      inherit plugins;
      inherit system;
      inherit systemPAM;
      inherit username;
      inherit wrapGL;
    })
    (import ./ignis.nix {
      inherit accent;
      inherit ignis;
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
    ./packages.nix
    ./quickshell.nix
    ./sound.nix
    ./starship.nix
    (import ./theme.nix {
      inherit accent;
      inherit flavor;
      inherit pkgs;
    })
    ./tmux.nix
  ];
  home = {
    homeDirectory = "/home/${username}";
    stateVersion = stateVersion;
    username = "${username}";
  };
  nixGL = {
    defaultWrapper = "mesa";
    packages = nixgl.packages;
  };
  nixpkgs.config = {
    inherit allowUnfreePredicate;
  };
  programs.home-manager.enable = true;
  targets.genericLinux.enable = genericLinux;
  xdg.configFile."environment.d/envvars.conf".text = ''
    PATH="$HOME/.nix-profile/bin:$HOME/.cargo/bin:$PATH"
  '';
}

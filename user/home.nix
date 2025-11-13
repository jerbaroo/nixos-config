{
  accent,
  allowUnfree,
  catppuccin,
  codeFontName,
  color-schemes,
  config,
  flavor,
  hyprland,
  hyprsplit,
  hyprtasking,
  genericLinux,
  ignis,
  niri,
  nixgl,
  pkgs,
  pkgs-unstable,
  plugins,
  stateVersion,
  system,
  systemPAM,
  username,
  wrapGL,
  ...
}:
let
  palette =
    (pkgs.lib.importJSON (config.catppuccin.sources.palette + "/palette.json")).${flavor}.colors;
in
{
  imports = [
    catppuccin.homeModules.catppuccin
    ignis.homeManagerModules.default

    ./browser.nix
    ./direnv.nix
    (import ./emacs.nix {
      inherit codeFontName;
      inherit flavor;
      inherit pkgs;
    })
    ./fish.nix
    ./fonts.nix
    (import ./ghostty.nix {
      inherit codeFontName;
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
      inherit hyprland;
      inherit hyprsplit;
      inherit hyprtasking;
      inherit palette;
      inherit pkgs;
      inherit plugins;
      inherit system;
      inherit systemPAM;
      inherit wrapGL;
    })
    (import ./ignis.nix {
      inherit accent;
      inherit ignis;
      inherit palette;
      inherit pkgs;
    })
    (import ./kitty.nix {
      inherit codeFontName;
      inherit config;
      inherit pkgs;
      inherit wrapGL;
    })
    ./lsd.nix
    (import ./neovim.nix {
      inherit pkgs;
      inherit pkgs-unstable;
    })
    ./packages.nix
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
    inherit allowUnfree;
  };
  programs.home-manager.enable = true;
  targets.genericLinux.enable = genericLinux;
  xdg.configFile."environment.d/envvars.conf".text = ''
    PATH="$HOME/.nix-profile/bin:$PATH"
  '';
}

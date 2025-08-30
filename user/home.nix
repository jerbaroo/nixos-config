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
  nixgl,
  pkgs,
  pkgs-unstable,
  plugins,
  stateVersion,
  system,
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

    ../user/browser.nix
    ../user/direnv.nix
    (import ../user/emacs.nix {
      inherit codeFontName;
      inherit flavor;
      inherit pkgs;
    })
    ../user/fish.nix
    ../user/fonts.nix
    (import ../user/ghostty.nix {
      inherit codeFontName;
      inherit color-schemes;
      inherit config;
      inherit flavor;
      inherit pkgs;
      inherit system;
      inherit wrapGL;
    })
    ../user/git.nix
    (import ../user/hyprland.nix {
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
      inherit wrapGL;
    })
    (import ../user/ignis.nix {
      inherit accent;
      inherit ignis;
      inherit palette;
      inherit pkgs;
      inherit system;
    })
    (import ../user/kitty.nix {
      inherit codeFontName;
      inherit config;
      inherit pkgs;
      inherit wrapGL;
    })
    ../user/lsd.nix
    (import ../user/neovim.nix {
      inherit pkgs;
      inherit pkgs-unstable;
    })
    ../user/packages.nix
    ../user/starship.nix
    (import ../user/theme.nix {
      inherit accent;
      inherit flavor;
      inherit pkgs;
    })
    ../user/tmux.nix
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
}

{
  accent,
  codeFontName,
  config,
  flavor,
  inputs,
  palette,
  pkgs,
  pkgs-unstable,
  stateVersion,
  system,
  username,
  ...
}:
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin

    # TODO better way to pass args to modules.
    ../user/browser.nix
    (import ../user/ignis.nix {
      inherit accent;
      inherit inputs;
      inherit palette;
      inherit pkgs;
      inherit system;
    })
    ../user/direnv.nix
    (import ../user/emacs.nix {
      inherit codeFontName;
      inherit flavor;
      inherit pkgs;
    })
    ../user/fish.nix
    ../user/fonts.nix
    ../user/git.nix
    (import ../user/ghostty.nix {
      inherit codeFontName;
      inherit flavor;
      inherit inputs;
      inherit pkgs;
      inherit system;
    })
    (import ../user/hyprland.nix {
      inherit accent;
      inherit flavor;
      inherit inputs;
      inherit palette;
      inherit pkgs;
      inherit system;
    })
    (import ../user/kitty.nix {
      inherit codeFontName;
      inherit pkgs;
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
}

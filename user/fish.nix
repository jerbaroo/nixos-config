{ hostname, pkgs, username, ... }:
let
  plugin = x: {
    name = x;
    src = pkgs.fishPlugins.${x}.src;
  };
in
{
  programs.fish = {
    enable = true;
    shellAbbrs = {
      d = "git diff";
      dr = "direnv reload";
      grep = "batgrep";
      l = "lsd";
      man = "batman";
      os-switch-nixos = "sudo nixos-rebuild switch --flake .#nixos";
      os-switch-home = "${pkgs.nh}/bin/nh home switch /home/${username}/nixos-config/.#homeConfigurations.${username}@${hostname}.activationPackage";
      s = "git status";
      watch = "batwatch";
    };
    plugins = map plugin [
      "autopair"
      "bang-bang"
      "done"
      "forgit"
      "fzf-fish"
      "grc"
      "humantime-fish"
      "z"
    ];
    shellInit = ''
      fish_vi_key_bindings
      set fish_greeting
      if status is-interactive
      and not set -q TMUX
        # Create session 'main' or attach to 'main' if already exists.
        tmux new-session -A -s main
      end
    '';
  };
  programs.fzf = {
    enable = true;
    enableFishIntegration = false;
  };
}

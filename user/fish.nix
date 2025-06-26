{ pkgs, ... }:
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
      dr = "direnv reload";
      grep = "batgrep";
      man = "batman";
      rebuild = "sudo nixos-rebuild switch --flake .#nixos";
      watch = "batwatch";
    };
    plugins = with pkgs.fishPlugins; [
      (plugin "autopair")
      (plugin "bang-bang")
      (plugin "done")
      (plugin "forgit")
      (plugin "fzf-fish")
      (plugin "grc")
      (plugin "humantime-fish")
      (plugin "tide")
      (plugin "z")
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

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
      (plugin "grc")
      (plugin "humantime-fish")
      (plugin "tide")
      (plugin "fzf-fish")
      (plugin "z")
    ];
    shellInit = ''
      tide configure --auto --style=Rainbow --prompt_colors='True color' --show_time=No --rainbow_prompt_separators=Slanted --powerline_prompt_heads=Slanted --powerline_prompt_tails=Flat --powerline_prompt_style='Two lines, character' --prompt_connection=Solid --powerline_right_prompt_frame=No --prompt_connection_andor_frame_color=Lightest --prompt_spacing=Compact --icons='Many icons' --transient=Yes
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

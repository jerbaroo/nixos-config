{ accent, hostname, lib, pkgs, username, ... }:
let
  plugin = x: {
    name = x;
    src = pkgs.fishPlugins.${x}.src;
  };
in
{
  home.packages = with pkgs; [ grc ];
  programs.fish = {
    enable = true;
    shellAbbrs = {
      d = "git diff";
      dr = "direnv reload";
      grep = "batgrep";
      f = "fixup";
      g = "git";
      l = "lsd";
      man = "batman";
      os-switch-nixos = "sudo nixos-rebuild switch --flake .#nixos";
      os-switch-home = "cd ~ && ${pkgs.nh}/bin/nh home switch /home/${username}/nixos-config/.#homeConfigurations.${username}@${hostname}.activationPackage; cd -";
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

      function fixup
        commandline "git commit --fixup "
        _fzf_search_git_log
        commandline -i " "
      end

      function fzf --wraps=fzf --description="Use fzf-tmux if in tmux session"
        if test -n "$TMUX"
          ${pkgs.fzf}/bin/fzf-tmux -p '80%,80%' $argv
        else
          echo $argv > tmp.out
          command fzf $argv
        end
      end
    '';
    shellInitLast = ''
      if test -n "$TMUX"
        and test (tmux display-message -p '#S#{window_index}') = "main1"
        and test "$TMUX_PANE" = '%0'
        ${pkgs.neo}/bin/neo -D -f 120 -F -c ${accent}
      end
    '';
  };
  programs.fzf = {
    colors = {
      bg = lib.mkForce "-1"; # Transparent.
      "bg+" = lib.mkForce "-1"; # Transparent.
    };
    enable = true;
    enableFishIntegration = false; # Just for the config file. Prefer fzf.fish.
  };
}

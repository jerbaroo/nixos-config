{ hostname, pkgs, username, ... }:
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
      function fixup
        commandline "git commit --fixup "
        _fzf_search_git_log
        commandline -i " "
      end
    '';
    shellInitLast = ''
      if test -n "$TMUX"; and test (tmux display-message -p '#S#{window_index}') = "main1";
        ${pkgs.neo}/bin/neo -D -f 120 -F -c pink
      end
    '';
  };
  programs.fzf = {
    defaultOptions = [ "--color=bg:-1,bg+:-1" ];
    enable = true;
    enableFishIntegration = false;
  };
}

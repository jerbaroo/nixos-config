{
  programs.fish = {
    enable = true;
    shellAbbrs = {
      dr = "direnv reload";
      ga = "git add";
      gb = "git branch";
      gc = "git commit";
      gd = "git diff";
      gf = "git pull";
      gl = "git log";
      go = "git checkout";
      gp = "git push";
      gr = "git reset";
      gs = "git status";
      rebuild = "sudo nixos-rebuild switch --flake .#nixos";
    };
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
}

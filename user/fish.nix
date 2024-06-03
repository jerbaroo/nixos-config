{
  programs.fish = {
    enable = true;
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

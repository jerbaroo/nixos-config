{ accent, hostname, lib, pkgs, username, ... }:
let
  os-neo = pkgs.writeShellScriptBin "os-neo"
    "${pkgs.neo}/bin/neo -D -f 120 -F -c ${accent}";
  plugin = x: {
    name = x;
    src = pkgs.fishPlugins.${x}.src;
  };
in
{
  home.packages = with pkgs; [ grc ];
  programs.fish = {
    enable = true;
    functions = {
      git_fixup = ''
        commandline "git commit --fixup "
        _fzf_search_git_log
        commandline -i " "
      '';
      # git status for file at path $argv1, useful for fzf preview.
      git_preview = ''
        set -l path (string replace '~' $HOME $argv[1])
        ${pkgs.git}/bin/git -C $path status -b -s
        echo
        ${pkgs.lsd}/bin/lsd $path
      '';
      # Run command in a tmux popup if within tmux, else run it normally.
      in_tmux_popup = ''
        if test -n "$TMUX"
          tmux display-popup -E -w '80%' -h '80%' $argv
        else
          eval $argv
        end
      '';
      # Select projects from home directory. Project format: '~/foo'.
      project_select = ''
        set -l custom_paths
        set -l ignore_paths
        set -l projects_path ~/.projects
        if test -f $projects_path
          for line in (cat $projects_path | string split '\n' | string trim)
            if string match -q 'ignore:*' $line
              set -a ignore_paths -E (echo $line | string replace 'ignore:' "" | string trim)
            else
              set -a custom_paths $line
            end
          end
        end
        string replace -r '^' '~/' $custom_paths
        ${pkgs.fd}/bin/fd $ignore_paths '^\.git$' "$HOME" \
          --unrestricted -t f -t d -x dirname \
          | string replace $HOME "~"
      '';
      tmux_project_open = ''
        set project_selection \
          ( project_select \
          | ${pkgs.fzf}/bin/fzf --reverse --preview 'echo hi' \
          )
        echo $project_selection

        # If an empty project.
        if test -n "$project_selection"

          set project_path (eval echo $project_selection)
          # If project directory does exist.
          if test -d "$project_path"

            set project_name (path basename $project_path)
            if test -n "$project_name"

              # Create a session for the project if it doesn't exist.
              if not ${pkgs.tmux}/bin/tmux has-session -t $project_name 2> /dev/null
                ${pkgs.tmux}/bin/tmux new-session -d -s "$project_name" -c "$project_path"
                ${pkgs.tmux}/bin/tmux send-keys -t "$project_name" "$EDITOR ." C-m
              end
              # Switch to the project's session.
              tmux-switch-or-attach "$project_name"

            end
          end
        end

      '';
      tmux_session_open = ''
        set current_sess (${pkgs.tmux}/bin/tmux display-message -p '#{session_name}')
        set current_win (${pkgs.tmux}/bin/tmux display-message -p '#{window_id}')

        # Command to preview a tmux sessions.
        set preview_cmd "if test \"$current_sess\" = '{}'; \
            ${pkgs.tmux}/bin/tmux capture-pane -e -p -t \"$current_win\"; \
          else; \
            ${pkgs.tmux}/bin/tmux capture-pane -e -p -t {}; \
          end;"

        # Command to list tmux sessions.
        set target \
          ( ${pkgs.tmux}/bin/tmux list-sessions -F '#{session_name}' \
          | ${pkgs.fzf}/bin/fzf --reverse --preview 'echo hi' \
          )

        if test -n "$target"
          tmux_switch_or_attach "$target"
        end
      '';
      tmux_switch_or_attach = ''
        if test -n "$TMUX"
          ${pkgs.tmux}/bin/tmux switch-client -t "$argv"
        else
          ${pkgs.tmux}/bin/tmux attach-session -t "$argv"
        end
      '';
      # Run the command in a new window with a background command iff TMUX_BG is
      # set AND we are within tmux, otherwise run the command normally.
      with_tmux_bg = ''
        set TMUX_BG ${os-neo}/bin/os-neo # Here for now..
        echo "TMUX: $TMUX"
        if test -n "$TMUX"; and test -n "$TMUX_BG";
          set bg_window_name "$argv[1]"
          echo "bg_window_name: $bg_window_name"

          set current_win (${pkgs.tmux}/bin/tmux display-message -p '#{session_name}:#{window_id}')
          echo "current_win: $current_win"
          set session_name (${pkgs.tmux}/bin/tmux display-message -p '#{session_name}')
          echo "session_name: $session_name"

          # Remove background on exit (only if inside tmux).
          function cleanup_bg --inherit-variable current_win --inherit-variable session_name --inherit-variable bg_window_name
            ${pkgs.tmux}/bin/tmux select-window -t "$current_win"
            ${pkgs.tmux}/bin/tmux kill-window -t "$session_name:$bg_window_name"
          end

          trap cleanup_bg INT TERM

          # Setup background (only if inside tmux).
          ${pkgs.tmux}/bin/tmux new-window -d -n "$bg_window_name" "$TMUX_BG"
          ${pkgs.tmux}/bin/tmux select-window -t "$bg_window_name"
        end

        in_tmux_popup "eval \"$argv[2]\""
        echo 'with_tmux_bg: command finished'

        # We check if the function exists (meaning we are in tmux) and run it.
        if functions -q cleanup_bg
          echo 'with_tmux_bg: cleaning up'
           cleanup_bg
           trap - INT TERM # Clear the trap so it doesn't run again
        end
      '';
    };
    shellAbbrs = {
      d = "git diff";
      dr = "direnv reload";
      grep = "batgrep";
      f = "git_fixup";
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
    '';
  };
  programs.fzf = {
    colors = {
      bg = lib.mkForce "-1"; # Use terminal background colour.
      "bg+" = lib.mkForce "-1"; # Use terminal background colour.
    };
    enable = true;
    enableFishIntegration = false; # Just for the config file. Prefer fzf.fish.
  };
}

{ pkgs, ... }:
{
  # catppuccin.tmux.enable = false;
  programs.tmux = {
    baseIndex = 1;
    clock24 = true;
    disableConfirmationPrompt = true;
    enable = true;
    historyLimit = 10000000;
    keyMode = "vi";
    mouse = true;
    secureSocket = true;
    sensibleOnTop = true;
    shortcut = "a";
    shell = "${pkgs.fish}/bin/fish";
    extraConfig = ''
      set -g escape-time 0
      set -g default-terminal "tmux-256color"
      set -ga terminal-overrides ",*:RGB"
      set -g set-clipboard on
      unbind %
      unbind '"'
      bind | split-window -h -c "#{pane_current_path}"
      bind v split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind s split-window -v -c "#{pane_current_path}"
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R
      unbind r
      bind r source-file $HOME/.config/tmux/tmux.conf
      set -g base-index 1
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on
      bind -n S-Left previous-window
      bind -n S-Right next-window
      bind -n M-1 select-window -t 1
      bind -n M-2 select-window -t 2
      bind -n M-3 select-window -t 3
      bind -n M-4 select-window -t 4
      bind -n M-5 select-window -t 5
      bind -n M-6 select-window -t 6
      bind -n M-7 select-window -t 7
      bind -n M-8 select-window -t 8
      bind -n M-9 select-window -t 9
    '';
  };
}

{ accent, palette, pkgs, ... }:
{
  catppuccin.tmux.enable = false;
  programs.tmux = {
    aggressiveResize = true;
    baseIndex = 1;
    clock24 = true;
    disableConfirmationPrompt = true;
    enable = true;
    escapeTime = 0;
    historyLimit = 1000000000;
    keyMode = "vi";
    mouse = true;
    secureSocket = true;
    sensibleOnTop = true;
    shortcut = "a";
    shell = "${pkgs.fish}/bin/fish";
    terminal = "tmux-256color";
    extraConfig = ''
      # Theming.
      set -as terminal-features ",*:RGB" # True color.
      set -g pane-active-border-style fg=${palette.${accent}.hex}
      set -g pane-border-lines heavy
      set -g pane-border-style fg=${palette.base.hex}
      set -g message-command-style bg=${palette.base.hex},fg=${palette.text.hex}
      set -g message-style bg=${palette.base.hex},fg=${palette.text.hex}
      set -g status-left-style fg=${palette.text.hex}
      set -g prompt-cursor-colour "${palette.${accent}.hex}"
      set -g status-right ""
      set -g status-style bg=default # Transparent status bar background.
      set -g window-status-separator " "
      set -g window-status-style fg=${palette.text.hex}
      set -g window-status-current-style bg=${palette.base.hex},fg="${palette.${accent}.hex} bold"

      # Renumber windows.
      set -g renumber-windows on

      # Reload configuration.
      unbind r
      bind r source-file $HOME/.config/tmux/tmux.conf

      # Clipboard.
      set -g set-clipboard on
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      unbind -T copy-mode-vi MouseDragEnd1Pane

      # Split panes.
      unbind %
      unbind '"'
      bind | split-window -h -c "#{pane_current_path}"
      bind v split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind s split-window -v -c "#{pane_current_path}"

      # Select panes.
      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R

      # Select windows.
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

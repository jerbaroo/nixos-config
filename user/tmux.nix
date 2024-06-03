{ pkgs, ... }: {
  programs.tmux = {
    baseIndex = 1;
    clock24 = true;
    disableConfirmationPrompt = true;
    enable = true;
    historyLimit = 1000000;
    keyMode = "vi";
    newSession = true;
    secureSocket = true;
    shortcut = "a";
    shell = "${pkgs.fish}/bin/fish";
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
    ];
    extraConfig = ''
      set -g mouse on
    '';
  };
}

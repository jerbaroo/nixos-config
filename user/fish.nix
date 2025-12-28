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
    functions = {
      fzf_projects = ''
        project_select | fzf_tmux --preview "git_preview {}"
      '';
      fzf_tmux = ''
        if test -n "$TMUX"
          ${pkgs.fzf}/bin/fzf-tmux --reverse -p '80%,80%' $argv
        else
          command fzf $argv
        end
      '';
      git_fixup = ''
        commandline "git commit --fixup "
        _fzf_search_git_log
        commandline -i " "
      '';
      git_preview = ''
        set -l path (string replace '~' $HOME $argv[1])
        ${pkgs.git}/bin/git -C $path -c color.status=always status -s
        echo
        ${pkgs.lsd}/bin/lsd $path
      '';
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
        # Change directory without affecting user shell.
        begin
          cd ~
          string join '\n' $custom_paths
          ${pkgs.fd}/bin/fd $ignore_paths --unrestricted -t f -t d '^\.git$' . -x dirname \
            | string replace -r '^\.\/' ""
        end | string replace -r '^' '~/'
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

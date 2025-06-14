{
  accent,
  flavor,
  inputs,
  palette,
  pkgs,
  system,
  ...
}:
let
  wallpaper = pkgs.fetchurl {
    hash = "sha256-zHeCa5pStkUQqanUVww3KMehog5tSXrfEKPgd0fqgME=";
    url = "https://raw.githubusercontent.com/dharmx/walls/refs/heads/main/mountain/a_mountain_range_with_dark_clouds.jpg";
  };
in
{
  home.packages = with pkgs; [
    grim
    # hyprexpo
    hyprpicker
    slurp
    swappy
    wl-clipboard
  ];
  programs.hyprlock = {
    enable = true;
    settings = {
      general.hide_cursor = true;
    };
  };
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "off";
      preload = [ (builtins.toString wallpaper) ];
      splash = false;
      wallpaper = [ ",${(builtins.toString wallpaper)}" ];
    };
  };
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${system}.hyprland;
    plugins = [
      # inputs.hyprland-plugins.packages.${system}.hyprexpo
    ];
    settings = {
      # "env" = "GTK_THEME, catppuccin-${flavor}-${accent}-standard";
      "$mod" = "SUPER";
      animations = {
        enabled = true;
        first_launch_animation = false;
        # bezier = ["wind, 0.05, 0.9, 0.1, 1.05"];
      };
      bind = [
        "$mod, C, killactive"
        "$mod, B, exec, brave"
        "$mod, E, exec, emacs"
        "$mod, F, fullscreen"
        # "$mod, T, hyprexpo:expo, toggle"
        "$mod, M, exec, ags -t applauncher"
        "$mod, Q, exec, hyprlock"
        "$mod, O, exec, ignis open-window ignis-app-launcher"
        "$mod, RETURN, exec, ghostty"
        "$mod, P, exec, hyprpicker --autocopy"
        "$mod SHIFT, P, exec, hyprpicker --autocopy --render-inactive"
        "$mod, S, exec, grim -g \"$(slurp)\" - | swappy -f -"
        "$mod, T, togglesplit, # dwindle"
        "$mod, V, togglefloating"
        "$mod, W, exec, librewolf"
        # Scratch pad.
        # "$mod, S, togglespecialworkspace, magic"
        # "$mod SHIFT, S, movetoworkspace, special:magic"
        # Focus navigation.
        "$mod, H, movefocus, l"
        "$mod, J, movefocus, d"
        "$mod, K, movefocus, u"
        "$mod, L, movefocus, r"
        # Window navigation.
        "$mod CTRL, H, movewindow, l"
        "$mod CTRL, J, movewindow, d"
        "$mod CTRL, K, movewindow, u"
        "$mod CTRL, L, movewindow, r"
        "$mod SHIFT, H, swapwindow, l"
        "$mod SHIFT, J, swapwindow, d"
        "$mod SHIFT, K, swapwindow, u"
        "$mod SHIFT, L, swapwindow, r"
        # Drag/resize windows. TODO: broken.
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizeactive"
        # Switch focus to workspace.
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 0"
        # Move window to workspace.
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 0"
      ];
      decoration = {
        active_opacity = 1;
        inactive_opacity = 1;
        rounding = 3;
      };
      dwindle = {
        preserve_split = true;
      };
      exec-once = [
        "ignis init"
        "[workspace 1 silent] emacs"
        "[workspace 1 silent] ghostty"
        "[workspace 2 silent] librewolf"
      ];
      general = {
        border_size = 3;
        # Catppuccin mocha yellow. TODO
        "col.active_border" = "rgb(${pkgs.lib.strings.removePrefix "#" palette.${accent}.hex})";
        # "col.inactive_border" = "rgb(282a36)";
        gaps_in = 5;
        gaps_out = 10; # Should be double of 'gaps_in'.
        resize_on_border = true;
      };
      misc.disable_hyprland_logo = true;
    };
  };
}

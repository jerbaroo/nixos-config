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
    hyprpicker
    hyprsunset
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
      wallpaper = [ ",${builtins.toString wallpaper}" ];
    };
  };
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${system}.hyprland;
    plugins = [
      inputs.hypr-dynamic-cursors.packages.${system}.hypr-dynamic-cursors
      inputs.hyprsplit.packages.${system}.hyprsplit
      inputs.hyprtasking.packages.${pkgs.system}.hyprtasking
    ];
    settings = {
      # "env" = "GTK_THEME, catppuccin-${flavor}-${accent}-standard";
      "$mod" = "SUPER";
      animations = {
        # https://github.com/mylinuxforwork/dotfiles/blob/main/share/dotfiles/.config/hypr/conf/animations/animations-dynamic.conf
        animation = [
          "windows, 1, 6, wind, slide"
          "windowsIn, 1, 6, winIn, slide"
          "windowsOut, 1, 5, winOut, slide"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 1, liner"
          "borderangle, 1, 30, liner, loop"
          "fade, 1, 10, default"
          "workspaces, 1, 5, wind"
        ];
        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 1, 1, 1, 1"
        ];
        enabled = true;
        first_launch_animation = true;
      };
      bind = [
        "$mod, SPACE, exec, ignis open-window ignis-app-launcher"
        "$mod, RETURN, exec, ghostty"
        "$mod, C, killactive"
        "$mod, B, exec, brave"
        "$mod, E, exec, emacs"
        "$mod, F, fullscreen"
        "$mod SHIFT, F, fullscreenstate, 1"
        "$mod, O, hyprtasking:toggle, cursor"
        "$mod, P, exec, hyprpicker --autocopy"
        "$mod SHIFT, P, exec, hyprpicker --autocopy --render-inactive"
        "$mod, Q, exec, hyprlock"
        "$mod, S, exec, grim -g \"$(slurp)\" - | swappy -f -"
        "$mod, T, togglesplit, # dwindle"
        "$mod, V, togglefloating"
        "$mod, W, exec, librewolf"
        # Focus navigation.
        "$mod, H, movefocus, l"
        "$mod, J, movefocus, d"
        "$mod, K, movefocus, u"
        "$mod, L, movefocus, r"
        # Window navigation.
        "$mod CTRL, H, hyprtasking:move, l"
        "$mod CTRL, J, hyprtasking:move, d"
        "$mod CTRL, K, hyprtasking:move, u"
        "$mod CTRL, L, hyprtasking:move, r"
        "$mod SHIFT, H, swapwindow, l"
        "$mod SHIFT, J, swapwindow, d"
        "$mod SHIFT, K, swapwindow, u"
        "$mod SHIFT, L, swapwindow, r"
        # Switch focus to workspace.
        "$mod, 1, split:workspace, 1"
        "$mod, 2, split:workspace, 2"
        "$mod, 3, split:workspace, 3"
        "$mod, 4, split:workspace, 4"
        "$mod, 5, split:workspace, 5"
        "$mod, 6, split:workspace, 6"
        "$mod, 7, split:workspace, 7"
        "$mod, 8, split:workspace, 8"
        "$mod, 9, split:workspace, 9"
        "$mod, 0, split:workspace, 0"
        # Move window to workspace.
        "$mod SHIFT, 1, split:movetoworkspace, 1"
        "$mod SHIFT, 2, split:movetoworkspace, 2"
        "$mod SHIFT, 3, split:movetoworkspace, 3"
        "$mod SHIFT, 4, split:movetoworkspace, 4"
        "$mod SHIFT, 5, split:movetoworkspace, 5"
        "$mod SHIFT, 6, split:movetoworkspace, 6"
        "$mod SHIFT, 7, split:movetoworkspace, 7"
        "$mod SHIFT, 8, split:movetoworkspace, 8"
        "$mod SHIFT, 9, split:movetoworkspace, 9"
        "$mod SHIFT, 0, split:movetoworkspace, 0"
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
        "hyprsunset -t 5000"
        "openrgb -m static -c ff1e00"
        "ignis init"
        "[workspace 1 silent] emacs"
        "[workspace 1 silent] ghostty"
      ];
      general = {
        border_size = 3;
        "col.active_border" = "rgb(${pkgs.lib.strings.removePrefix "#" palette.${accent}.hex})";
        # "col.inactive_border" = "rgb(282a36)";
        gaps_in = 5;
        gaps_out = 10; # Should be double of 'gaps_in'.
        resize_on_border = true;
      };
      misc.disable_hyprland_logo = true;
      "plugin:dynamic-cursors" = {
        mode = "tilt";
        threshold = 1;
        tilt = {
          function = "quadratic";
          limit = 200;
        };
        shaperule = [ "text, none" ];
      };
      "plugin:hyprtasking" = {
        bg_color = "0x${pkgs.lib.strings.removePrefix "#" palette.crust.hex}";
      };
    };
  };
}

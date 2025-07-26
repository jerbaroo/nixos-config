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
  wallpaper = builtins.toString (pkgs.fetchurl {
    hash = "sha256-zHeCa5pStkUQqanUVww3KMehog5tSXrfEKPgd0fqgME=";
    url = "https://raw.githubusercontent.com/dharmx/walls/refs/heads/main/mountain/a_mountain_range_with_dark_clouds.jpg";
  });
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
      preload = [ wallpaper ];
      splash = false;
      wallpaper = [ ",${wallpaper}" ];
    };
  };
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${system}.hyprland;
    plugins = [
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
          "border, 1, 1, linear"
          "borderangle, 1, 30, linear, loop"
          "fade, 1, 10, default"
          "workspaces, 1, 5, wind"
        ];
        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "linear, 1, 1, 1, 1"
        ];
        enabled = true;
        first_launch_animation = true;
      };
      bind = [
        # Overview controls.
        "$mod, O     , hyprtasking:toggle, cursor"
        "$mod, RETURN, hyprtasking:if_active, hyprtasking:toggle cursor"
        "    , RETURN, hyprtasking:if_active, hyprtasking:toggle cursor"
        "$mod, H     , hyprtasking:if_active, hyprtasking:move left"
        "    , H     , hyprtasking:if_active, hyprtasking:move left"
        "$mod, J     , hyprtasking:if_active, hyprtasking:move down"
        "    , J     , hyprtasking:if_active, hyprtasking:move down"
        "$mod, K     , hyprtasking:if_active, hyprtasking:move up"
        "    , K     , hyprtasking:if_active, hyprtasking:move up"
        "$mod, L     , hyprtasking:if_active, hyprtasking:move right"
        "    , L     , hyprtasking:if_active, hyprtasking:move right"
        # Move focus in direction.
        "$mod, H, hyprtasking:if_not_active, movefocus l"
        "$mod, J, hyprtasking:if_not_active, movefocus d"
        "$mod, K, hyprtasking:if_not_active, movefocus u"
        "$mod, L, hyprtasking:if_not_active, movefocus r"
        # Swap windows in direction.
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, J, movewindow, d"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, L, movewindow, r"
        # Move focus to workspace in direction.
        "$mod CTRL, H, hyprtasking:move, left"
        "$mod CTRL, J, hyprtasking:move, down"
        "$mod CTRL, K, hyprtasking:move, up"
        "$mod CTRL, L, hyprtasking:move, right"
        # Move focus to workspace by ID.
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
        # Move window to workspace by ID.
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
        # Application shortcuts.
        "$mod, SPACE, exec, ignis open-window ignis-app-launcher"
        "$mod, RETURN, hyprtasking:if_not_active, exec ghostty"
        "$mod, B, exec, blueman-manager"
        "$mod, C, killactive"
        "$mod, E, exec, emacs"
        "$mod, F, fullscreen"
        "$mod, G, togglefloating"
        "$mod SHIFT, F, fullscreenstate, 1"
        "$mod, P, exec, hyprpicker --autocopy"
        "$mod SHIFT, P, exec, hyprpicker --autocopy --render-inactive"
        "$mod, Q, exec, hyprlock"
        "$mod SHIFT, Q, exec, poweroff"
        # "$mod, S, exec, grim -g \"$(slurp)\" - | swappy -f -"
        "$mod, S, exec, grim -g \"$(slurp)\" - | wl-copy"
        "$mod, T, togglesplit, # dwindle"
        "$mod, V, exec, pavucontrol"
        "$mod, W, exec, librewolf"
        "$mod SHIFT, W, exec, brave"
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
      ];
      general = {
        border_size = 3;
        "col.active_border" = "rgb(${pkgs.lib.strings.removePrefix "#" palette.${accent}.hex})";
        "col.inactive_border" = "rgb(${pkgs.lib.strings.removePrefix "#" palette.crust.hex})";
        # "col.inactive_border" = "rgb(282a36)";
        gaps_in = 5;
        gaps_out = 10; # Should be double of 'gaps_in'.
        resize_on_border = true;
      };
      misc.disable_hyprland_logo = true;
      "plugin:hyprtasking" = {
        bg_color = "0xff${pkgs.lib.strings.removePrefix "#" palette.crust.hex}";
        border_size = 5;
        gap_size = 5;
        gaps_use_aspect_ratio = true;
      };
    };
  };
}

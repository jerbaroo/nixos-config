{
  accent,
  config,
  flavor,
  hyprland,
  hyprsplit,
  hyprtasking,
  palette,
  pkgs,
  plugins,
  system,
  systemPAM,
  wrapGL,
  ...
}:
let
  ifPlugins = a: if plugins then a else "";
  ifNotPlugins = a: if plugins then "" else a;
  hyprlock-systempam = (
    # Written by ChatGPT 5:
    pkgs.writeShellScriptBin "hyprlock" ''
      #!/usr/bin/env bash
      set -euo pipefail
      # Use the Hyprlock binary that Nix built
      REAL="${pkgs.hyprlock}/bin/hyprlock"
      # Force it to run under Ubuntu's dynamic loader instead of Nix's
      # (different distros may use /lib64 or /lib/x86_64-linux-gnu)
      LOADER="/lib64/ld-linux-x86-64.so.2"
      [ -x "$LOADER" ] || LOADER="/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2"
      # Tell the loader where to look for shared libraries first
      # These are Ubuntu's system lib dirs, so pam_unix & friends are found here
      export LD_LIBRARY_PATH="/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu"
      # Extra safety: preload system libpam.so explicitly, so we never use Nix's
      export LD_PRELOAD="/lib/x86_64-linux-gnu/libpam.so.0"
      # Finally, exec Hyprlock through the system loader with the correct libs
      exec "$LOADER" --library-path "$LD_LIBRARY_PATH" "$REAL" "$@"
    ''
  );
  wallpaper = builtins.toString (
    pkgs.fetchurl {
      hash = "sha256-zHeCa5pStkUQqanUVww3KMehog5tSXrfEKPgd0fqgME=";
      url = "https://raw.githubusercontent.com/dharmx/walls/refs/heads/main/mountain/a_mountain_range_with_dark_clouds.jpg";
    }
  );
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
    package = if systemPAM then hyprlock-systempam else pkgs.hyprlock;
    settings.general.hide_cursor = true;
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
    package = ((if wrapGL then config.lib.nixGL.wrap else (x: x)) hyprland.packages.${system}.hyprland);
    plugins =
      if plugins then
        [
          hyprsplit.packages.${system}.hyprsplit
          hyprtasking.packages.${pkgs.system}.hyprtasking
        ]
      else
        [ ];
    settings = {
      # "env" = "GTK_THEME, catppuccin-${flavor}-${accent}-standard";
      env = "GDK_BACKEND,wayland,x11,*";
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
      bind =
        (
          if plugins then
            [
              "$mod, O, hyprtasking:toggle, cursor"
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
            ]
          else
            [ ]
        )
        ++ [
          # Overview controls.
          # Move focus in direction.
          "$mod, H, ${ifPlugins "hyprtasking:if_not_active, "}movefocus${ifNotPlugins ","} l"
          "$mod, J, ${ifPlugins "hyprtasking:if_not_active, "}movefocus${ifNotPlugins ","} d"
          "$mod, K, ${ifPlugins "hyprtasking:if_not_active, "}movefocus${ifNotPlugins ","} u"
          "$mod, L, ${ifPlugins "hyprtasking:if_not_active, "}movefocus${ifNotPlugins ","} r"
          # Swap windows in direction.
          "$mod SHIFT, H, movewindow, l"
          "$mod SHIFT, J, movewindow, d"
          "$mod SHIFT, K, movewindow, u"
          "$mod SHIFT, L, movewindow, r"
          # Move focus to workspace in direction.
          # "$mod CTRL, H, ${ifPlugins "hyprtasking:move" "movefocus"}, left"
          # "$mod CTRL, J, ${ifPlugins "hyprtasking:move" "movefocus"}, down"
          # "$mod CTRL, K, ${ifPlugins "hyprtasking:move" "movefocus"}, up"
          # "$mod CTRL, L, ${ifPlugins "hyprtasking:move" "movefocus"}, right"
          # Move focus to workspace by ID.
          "$mod, 1, ${ifPlugins "split:"}workspace, 1"
          "$mod, 2, ${ifPlugins "split:"}workspace, 2"
          "$mod, 3, ${ifPlugins "split:"}workspace, 3"
          "$mod, 4, ${ifPlugins "split:"}workspace, 4"
          "$mod, 5, ${ifPlugins "split:"}workspace, 5"
          "$mod, 6, ${ifPlugins "split:"}workspace, 6"
          "$mod, 7, ${ifPlugins "split:"}workspace, 7"
          "$mod, 8, ${ifPlugins "split:"}workspace, 8"
          "$mod, 9, ${ifPlugins "split:"}workspace, 9"
          "$mod, 0, ${ifPlugins "split:"}workspace, 0"
          # Move window to workspace by ID.
          "$mod SHIFT, 1, ${ifPlugins "split:"}movetoworkspace, 1"
          "$mod SHIFT, 2, ${ifPlugins "split:"}movetoworkspace, 2"
          "$mod SHIFT, 3, ${ifPlugins "split:"}movetoworkspace, 3"
          "$mod SHIFT, 4, ${ifPlugins "split:"}movetoworkspace, 4"
          "$mod SHIFT, 5, ${ifPlugins "split:"}movetoworkspace, 5"
          "$mod SHIFT, 6, ${ifPlugins "split:"}movetoworkspace, 6"
          "$mod SHIFT, 7, ${ifPlugins "split:"}movetoworkspace, 7"
          "$mod SHIFT, 8, ${ifPlugins "split:"}movetoworkspace, 8"
          "$mod SHIFT, 9, ${ifPlugins "split:"}movetoworkspace, 9"
          "$mod SHIFT, 0, ${ifPlugins "split:"}movetoworkspace, 0"
          # Application shortcuts.
          "$mod, SPACE, exec, ignis open-window ignis-app-launcher"
          "$mod, RETURN, ${ifPlugins "hyprtasking:if_not_active, "}exec${ifNotPlugins ","} ghostty"
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
      debug.disable_logs = false;
      decoration = {
        active_opacity = 1;
        inactive_opacity = 1;
        rounding = 3;
      };
      dwindle.preserve_split = true;
      exec-once = [
        "hyprsunset -t 5000"
        "openrgb -m static -c ff1e00"
        "ignis init"
      ];
      general = {
        border_size = 2;
        "col.active_border" = "rgb(${pkgs.lib.strings.removePrefix "#" palette.${accent}.hex})";
        "col.inactive_border" = "rgb(${pkgs.lib.strings.removePrefix "#" palette.crust.hex})";
        # "col.inactive_border" = "rgb(282a36)";
        gaps_in = 3;
        gaps_out = 6; # Should be double of 'gaps_in'.
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
    xwayland.enable = true;
  };
}

{
  accent,
  config,
  flavor,
  ghdashboardPort,
  gap,
  hyprland,
  hyprsplit,
  hyprtasking,
  palette,
  pkgs,
  system,
  systemPAM,
  temperature,
  username,
  wrapGL,
  ...
}:
let
  ifPlugin = p: a: if p == null then "" else a;
  ifNotPlugin = p: a: if p == null then a else "";
  ghdashboard = (import ./ghdashboard/default.nix { inherit pkgs; });
  ghdashboardwithargs = pkgs.writeShellScriptBin "ghdashboardwithargs" "${ghdashboard}/bin/ghdashboard ${toString(ghdashboardPort)} /home/${username}/.config/read-gh-token.sh";
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
  os-current-monitor = pkgs.writeShellScriptBin "os-current-monitor" "hyprctl monitors | awk -F '[ ()]+' '/Monitor/ {id=$4} /focused: yes/ {print id; exit}'";
  os-lock = (import ./lock.nix { inherit palette; inherit pkgs; });
  os-screenshot = pkgs.writeShellScriptBin "os-screenshot" "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.swappy}/bin/swappy -f -";
  os-toggle-menu-bar = pkgs.writeShellScriptBin "os-toggle-menu-bar" "ignis toggle-window ignis-bar-$(${os-current-monitor}/bin/os-current-monitor)";
  wallpaper = (import ./wallpaper.nix { inherit pkgs; }).wallpaper;
in
{
  home.packages = [ ghdashboardwithargs os-current-monitor os-lock os-toggle-menu-bar ];
  programs.hyprlock = {
    enable = false;
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
  services.hyprpolkitagent.enable = true;
  services.hyprsunset = {
    enable = true;
    extraArgs = ["-t" "${toString(temperature)}"];
  };
  wayland.windowManager.hyprland = {
    enable = true;
    package = ((if wrapGL then config.lib.nixGL.wrap else (x: x)) hyprland.packages.${system}.hyprland);
    plugins =
         (if isNull hyprtasking then [] else [hyprtasking.packages.${pkgs.system}.hyprtasking])
      ++ (if isNull hyprsplit   then [] else [hyprsplit.packages.${system}.hyprsplit]);
    settings = {
      # "env" = "GTK_THEME, catppuccin-${flavor}-${accent}-standard";
      env = "GDK_BACKEND, wayland";
      "$mod" = "SUPER";
      # https://github.com/end-4/dots-hyprland/blob/main/dots/.config/hypr/hyprland/general.conf
      animations = {
        animation = [
          "windowsIn, 1, 3, emphasizedDecel, popin 80%"
          "fadeIn, 1, 3, emphasizedDecel"
          "windowsOut, 1, 2, emphasizedDecel, popin 90%"
          "fadeOut, 1, 2, emphasizedDecel"
          "windowsMove, 1, 3, emphasizedDecel, slide"
          "border, 1, 10, emphasizedDecel"
          "layersIn, 1, 2.7, emphasizedDecel, popin 93%"
          "layersOut, 1, 2.4, menu_accel, popin 94%"
          "fadeLayersIn, 1, 0.5, menu_decel"
          "fadeLayersOut, 1, 2.7, stall"
          "workspaces, 1, 7, menu_decel, slide"
          "specialWorkspaceIn, 1, 2.8, emphasizedDecel, slidevert"
          "specialWorkspaceOut, 1, 1.2, emphasizedAccel, slidevert"
        ];
        bezier = [
          "expressiveFastSpatial, 0.42, 1.67, 0.21, 0.90"
          "expressiveSlowSpatial, 0.39, 1.29, 0.35, 0.98"
          "expressiveDefaultSpatial, 0.38, 1.21, 0.22, 1.00"
          "emphasizedDecel, 0.05, 0.7, 0.1, 1"
          "emphasizedAccel, 0.3, 0, 0.8, 0.15"
          "standardDecel, 0, 0, 0, 1"
          "menu_decel, 0.1, 1, 0, 1"
          "menu_accel, 0.52, 0.03, 0.72, 0.08"
          "stall, 1, -0.1, 0.7, 0.85"
        ];
        enabled = true;
      };
      bind =
        (
          if isNull hyprtasking then [ ] else
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
        )
        ++ [
          ",XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 10%-"
          ",XF86MonBrightnessUp  , exec, ${pkgs.brightnessctl}/bin/brightnessctl s +10%"
          ",XF86AudioMute        , exec, ${pkgs.wireplumber}/bin/wpctl set-mute   @DEFAULT_SINK@ toggle"
          ",XF86AudioLowerVolume , exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ 5%-"
          ",XF86AudioRaiseVolume , exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ 5%+"
          # Move focus in direction.
          "$mod, H, ${ifPlugin hyprtasking "hyprtasking:if_not_active, "}movefocus${ifNotPlugin hyprtasking ","} l"
          "$mod, J, ${ifPlugin hyprtasking "hyprtasking:if_not_active, "}movefocus${ifNotPlugin hyprtasking ","} d"
          "$mod, K, ${ifPlugin hyprtasking "hyprtasking:if_not_active, "}movefocus${ifNotPlugin hyprtasking ","} u"
          "$mod, L, ${ifPlugin hyprtasking "hyprtasking:if_not_active, "}movefocus${ifNotPlugin hyprtasking ","} r"
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
          "$mod, 1, ${ifPlugin hyprsplit "split:"}workspace, 1"
          "$mod, 2, ${ifPlugin hyprsplit "split:"}workspace, 2"
          "$mod, 3, ${ifPlugin hyprsplit "split:"}workspace, 3"
          "$mod, 4, ${ifPlugin hyprsplit "split:"}workspace, 4"
          "$mod, 5, ${ifPlugin hyprsplit "split:"}workspace, 5"
          "$mod, 6, ${ifPlugin hyprsplit "split:"}workspace, 6"
          "$mod, 7, ${ifPlugin hyprsplit "split:"}workspace, 7"
          "$mod, 8, ${ifPlugin hyprsplit "split:"}workspace, 8"
          "$mod, 9, ${ifPlugin hyprsplit "split:"}workspace, 9"
          "$mod, 0, ${ifPlugin hyprsplit "split:"}workspace, 0"
          # Move window to workspace by ID.
          "$mod SHIFT, 1, ${ifPlugin hyprsplit "split:"}movetoworkspace, 1"
          "$mod SHIFT, 2, ${ifPlugin hyprsplit "split:"}movetoworkspace, 2"
          "$mod SHIFT, 3, ${ifPlugin hyprsplit "split:"}movetoworkspace, 3"
          "$mod SHIFT, 4, ${ifPlugin hyprsplit "split:"}movetoworkspace, 4"
          "$mod SHIFT, 5, ${ifPlugin hyprsplit "split:"}movetoworkspace, 5"
          "$mod SHIFT, 6, ${ifPlugin hyprsplit "split:"}movetoworkspace, 6"
          "$mod SHIFT, 7, ${ifPlugin hyprsplit "split:"}movetoworkspace, 7"
          "$mod SHIFT, 8, ${ifPlugin hyprsplit "split:"}movetoworkspace, 8"
          "$mod SHIFT, 9, ${ifPlugin hyprsplit "split:"}movetoworkspace, 9"
          "$mod SHIFT, 0, ${ifPlugin hyprsplit "split:"}movetoworkspace, 0"
          # Other shortcuts.
          "$mod      , RETURN, ${ifPlugin hyprtasking "hyprtasking:if_not_active, "}exec${ifNotPlugin hyprtasking ","} ghostty"
          "$mod      , SLASH, exec, ignis open-window ignis-app-launcher"
          "$mod      , SPACE, togglesplit, # dwindle"
          "$mod SHIFT, SPACE, togglefloating"
          "$mod      , TAB, workspace, m+1"
          "$mod      , B, exec, ${pkgs.blueman}/bin/blueman-manager"
          "$mod SHIFT, B, exec, ${os-toggle-menu-bar}/bin/os-toggle-menu-bar"
          "$mod      , C, exec, ${pkgs.cliphist}/bin/cliphist list | ${pkgs.rofi}/bin/rofi -dmenu | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy"
          "$mod      , D, exec, ${pkgs.wdisplays}/bin/wdisplays"
          "$mod      , E, exec, ${pkgs.emacs-pgtk}/bin/emacs"
          "$mod      , F, fullscreen"
          "$mod SHIFT, F, fullscreenstate, 1"
          "$mod      , M, exec, spotify"
          "$mod      , O, exec, ${pkgs.ghostty}/bin/ghostty --command=${pkgs.yazi}/bin/yazi"
          "$mod      , R, exec, ${pkgs.hyprpicker}/bin/hyprpicker --autocopy"
          "$mod SHIFT, R, exec, ${pkgs.hyprpicker}/bin/hyprpicker --autocopy --render-inactive"
          "$mod      , P, workspace, previous"
          "$mod      , Q, killactive"
          "$mod SHIFT, Q, exec, os-logout-menu"
          "$mod      , S, exec, ${os-screenshot}/bin/os-screenshot"
          "$mod      , V, exec, ${pkgs.pavucontrol}/bin/pavucontrol"
          "$mod      , W, exec, firefox"
          "$mod SHIFT, W, exec, ${pkgs.librewolf}/bin/librewolf"
        ];
      debug.disable_logs = false;
      decoration = {
        active_opacity = 1;
        blur = {
          enabled = true;
          noise = 0.02;
          passes = 4;
          size = 5;
        };
        inactive_opacity = 1;
        rounding = 10;
      };
      dwindle.preserve_split = true;
      exec-once = [
        # "openrgb -m static -c ff1e00"
        "1password --silent"
        "${ghdashboardwithargs}/bin/ghdashboardwithargs"
        "${pkgs.blueman}/bin/blueman-applet"
        "nm-applet"
        "ignis init"
      ];
      general = {
        border_size = 2;
        "col.active_border" = "rgb(${pkgs.lib.strings.removePrefix "#" palette.${accent}.hex})";
        "col.inactive_border" = "rgb(${pkgs.lib.strings.removePrefix "#" palette.base.hex})";
        gaps_in = gap;
        gaps_out = gap * 2;
        resize_on_border = true;
      };
      input.kb_options = "caps:swapescape";
      monitor = [ ", preferred, auto-up, 2" ];
      misc.disable_hyprland_logo = true;
      "plugin:hyprtasking" = {
        bg_color = "0xff${pkgs.lib.strings.removePrefix "#" palette.crust.hex}";
        border_size = gap;
        gap_size = gap;
        gaps_use_aspect_ratio = true;
      };
      windowrule = [
        "float true, match:class ^(org.pulseaudio.pavucontrol)$"
        "float true, match:class ^(.blueman-manager-wrapped)$"
        "float true, match:class ^(wdisplays)$"
      ];
    };
    # xwayland.enable = true;
  };
}

{
  accent,
  config,
  flavor,
  hyprland,
  hyprsplit,
  hyprtasking,
  palette,
  pkgs,
  system,
  systemPAM,
  wrapGL,
  ...
}:
let
  c = colour: pkgs.lib.strings.removePrefix "#" palette.${colour}.hex;
  ifPlugin = p: a: if p == null then "" else a;
  ifNotPlugin = p: a: if p == null then a else "";
  gap = 3;
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
  temperature = 4000;
  os-current-monitor = pkgs.writeShellScriptBin "os-current-monitor" "hyprctl monitors | awk -F '[ ()]+' '/Monitor/ {id=$4} /focused: yes/ {print id; exit}'";
  os-lock = pkgs.writeShellScriptBin "os-lock" ''
    swaylock \
      --font 'Atkinson Hyperlegible' \
      --font-size 196 \
      --indicator-caps-lock \
      --indicator-radius 256 \
      --indicator-thickness 64 \
      \
        --color ${c "base"} \
        --inside-color ${c "base"} \
        --line-color ${c "base"} \
        --ring-color ${c "blue"} \
        --separator-color ${c "base"} \
        --text-color ${c "text"} \
      \
        --key-hl-color ${c "pink"} \
        --bs-hl-color ${c "peach"} \
      \
        --inside-wrong-color ${c "red"} \
        --line-wrong-color ${c "red"} \
        --ring-wrong-color ${c "red"} \
        --text-wrong-color ${c "base"} \
      \
        --inside-ver-color ${c "green"} \
        --line-ver-color ${c "green"} \
        --ring-ver-color ${c "green"} \
        --text-ver-color ${c "base"} \
      \
        --inside-clear-color ${c "mauve"} \
        --line-clear-color ${c "mauve"} \
        --ring-clear-color ${c "mauve"} \
        --text-clear-color ${c "base"} \
      \
        --caps-lock-bs-hl-color ${c "yellow"} \
        --caps-lock-key-hl-color ${c "yellow"} \
        --inside-caps-lock-color ${c "base"} \
        --line-caps-lock-color ${c "yellow"} \
        --ring-caps-lock-color ${c "yellow"} \
        --text-caps-lock-color ${c "base"} \
      \
        --layout-bg-color ${c "base"} \
        --layout-border-color ${c "surface0"} \
        --layout-text-color ${c "text"}
'';
  os-toggle-menu-bar = pkgs.writeShellScriptBin "os-toggle-menu-bar" "ignis toggle-window ignis-bar-$(${os-current-monitor}/bin/os-current-monitor)";
  wallpaper = (import ./wallpaper.nix { inherit pkgs; }).wallpaper;
in
{
  home.packages = [ os-current-monitor os-lock os-toggle-menu-bar ];
  programs.niri = {
    enable = true;
    # package = ((if wrapGL then config.lib.nixGL.wrap else (x: x)) pkgs.niri );
    package = pkgs.niri-unstable; # TODO
  };
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
         (if isNull hyprtasking then [] else [hyprtasking.packages.${pkgs.system}.hyprtasking])
      ++ (if isNull hyprsplit   then [] else [hyprsplit.packages.${system}.hyprsplit]);
    settings = {
      # "env" = "GTK_THEME, catppuccin-${flavor}-${accent}-standard";
      env = "GDK_BACKEND, wayland";
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
          "$mod      , TAB, workspace, previous"
          "$mod      , B, exec, ${pkgs.blueman}/bin/blueman-manager"
          "$mod SHIFT, B, exec, ${os-toggle-menu-bar}/bin/os-toggle-menu-bar"
          "$mod      , C, exec, ${pkgs.cliphist}/bin/cliphist list | ${pkgs.rofi}/bin/rofi -dmenu | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy"
          "$mod      , D, exec, ${pkgs.wdisplays}/bin/wdisplays"
          "$mod      , E, exec, ${pkgs.emacs-pgtk}/bin/emacs"
          "$mod      , F, fullscreen"
          "$mod SHIFT, F, fullscreenstate, 1"
          "$mod      , M, exec, ${pkgs.spotify}/bin/spotify"
          "$mod      , O, exec, ${pkgs.ghostty}/bin/ghostty --command=${pkgs.yazi}/bin/yazi"
          "$mod      , P, exec, ${pkgs.hyprpicker}/bin/hyprpicker --autocopy"
          "$mod SHIFT, P, exec, ${pkgs.hyprpicker}/bin/hyprpicker --autocopy --render-inactive"
          "$mod      , Q, killactive"
          "$mod SHIFT, Q, exec, ${os-lock}/bin/os-lock & systemctl suspend"
          # "$mod, S, exec, grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.swappy}/bin/swappy -f -"
          "$mod      , S, exec, ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | wl-copy"
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
        "${pkgs.hyprsunset}/bin/hyprsunset -t ${pkgs.lib.strings.floatToString(temperature)}"
        # "openrgb -m static -c ff1e00"
        "ignis init"
        "${pkgs.blueman}/bin/blueman-applet"
        "nm-applet"
      ];
      general = {
        border_size = 2;
        "col.active_border" = "rgb(${pkgs.lib.strings.removePrefix "#" palette.${accent}.hex})";
        "col.inactive_border" = "rgb(${pkgs.lib.strings.removePrefix "#" palette.crust.hex})";
        gaps_in = gap;
        gaps_out = gap * 2;
        resize_on_border = true;
      };
      input.kb_options = "caps:swapescape";
      monitor = [
        ", preferred, auto-up, 2"
      ];
      misc.disable_hyprland_logo = true;
      "plugin:hyprtasking" = {
        bg_color = "0xff${pkgs.lib.strings.removePrefix "#" palette.crust.hex}";
        border_size = 5;
        gap_size = 5;
        gaps_use_aspect_ratio = true;
      };
      windowrule = [
        "float,class:^(org.pulseaudio.pavucontrol)$"
        "float,class:^(.blueman-manager-wrapped)$"
        "float,class:^(wdisplays)$"
      ];
    };
    # xwayland.enable = true; TODO setting
  };
}

{ accent, palette, pkgs, ... }:
let
  rgba = c: a: "rgba(${toString(c.r)}, ${toString(c.g)}, ${toString(c.b)}, ${toString(a)})";
  wallpaper-blurred = (import ./wallpaper.nix { inherit pkgs; }).wallpaper-blurred;
in {
  home.file."wallpaper-blurred.jpg".source = wallpaper-blurred;
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "os-lock";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "suspend";
        action = "os-lock & disown && systemctl suspend";
        text = "Sleep";
        keybind = "s";
      }
      {
        label = "logout";
        action = "hyprctl dispatch exit";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Poweroff";
        keybind = "p";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
    ];
  style = ''
    window {
      background-image: url("/home/jeremy-barisch-rooney/wallpaper-blurred.jpg");
      background-size: cover;
      font-size: 18px;
    }

    button {
      border: none;
      background-color: ${palette.base.hex};
      color: ${palette.${accent}.hex};
    }

    button:focus, button:hover {
      background-color: ${rgba palette.base.rgb 0.5};
    }

    button:first-child {
      border-radius: 10px 0 0 10px;
    }

    button:last-child {
      border-radius: 0 10px 10px 0;
    }
'';
  };
}

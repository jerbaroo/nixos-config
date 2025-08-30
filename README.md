![image](https://github.com/jerbaroo/nixos/assets/6631452/a53036a8-82a4-4287-acfd-e6edaac9eb00)

# Install

## NixOS
- Install NixOS 25.05.
- Install this NixOS config:
  - `sudo rm -rf /etc/nixos`
  - `git clone https://github.com/jerbaroo/nixos-config && cd nixos-config`
  - `sudo nixos-generate-config --show-hardware-config > system/hardware-configuration.nix`
  - `sudo nixos-rebuild switch --flake .#nixos`

## Ubuntu
- Install Ubuntu 25.04
- Install home-manager
- Install this home-manager config:
  - `git clone https://github.com/jerbaroo/nixos-config && cd nixos-config`
  - `home-manager --flake .#jer@nixos switch`

## Doom Emacs
- `git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs`
- `~/.config/emacs/bin/doom install` (No envvar file)
- If necessary: `rm -rf ~/.emacs.d`

``` yaml
[Desktop Entry]
Name=Hyprland
Comment=An intelligent dynamic tiling Wayland compositor
Exec=sh -c 'exec /home/jer/.nix-profile/bin/Hyprland > ~/.local/share/hyprland.log 2>&1'
Type=Application
```

# Develop ignis components
``` bash
ignis init -c ./user/ignis/config.py
```

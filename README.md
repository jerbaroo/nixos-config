![image](https://github.com/jerbaroo/nixos/assets/6631452/a53036a8-82a4-4287-acfd-e6edaac9eb00)

- Includes DEs: Cosmic Alpha 7, Hyprland 0.49

# Install
- Install NixOS 25.05.
- Install this NixOS configuration:
  - `sudo rm -rf /etc/nixos`
  - `git clone https://github.com/jerbaroo/nixos-config && cd nixos-config`
  - `sudo nixos-generate-config --show-hardware-config > system/hardware-configuration.nix`
  - `sudo nixos-rebuild switch --flake .#nixos`
- Install Doom Emacs:
  - `git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs`
  - `~/.config/emacs/bin/doom install`
  - gen envar N

# Ignis

``` bash
ignis init -c ./user/ignis/config.py
```

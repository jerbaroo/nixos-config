{ config, pkgs, wrapGL, ... }:
{
  programs.zed-editor = {
    enable = false;
    package = (if wrapGL then config.lib.nixGL.wrap else (x: x)) pkgs.zed-editor;
    # package = (if wrapGL then config.lib.nixGL.nixVulkanIntel else (x: x)) pkgs.zed-editor;
  };
}

{ pkgs, ... }:
{
  wallpaper = builtins.toString (
    pkgs.fetchurl {
      hash = "sha256-zHeCa5pStkUQqanUVww3KMehog5tSXrfEKPgd0fqgME=";
      url = "https://raw.githubusercontent.com/dharmx/walls/refs/heads/main/mountain/a_mountain_range_with_dark_clouds.jpg";
    }
  );
}

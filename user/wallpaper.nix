{ pkgs, ... }:
let
  wallpaper = builtins.toString wallpaper_import;
  wallpaper_import = ./wallpaper.jpg;
in {
  inherit wallpaper;
  wallpaper-blurred =
    pkgs.runCommand
      "blur-image"
      { nativeBuildInputs = [ pkgs.imagemagick ]; }
      "magick ${wallpaper_import} -blur 20x20 $out";
}

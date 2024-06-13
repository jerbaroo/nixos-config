{ accent, flavor, pkgs, ... }: {
  catppuccin = {
    accent = "${accent}";
    enable = true;
    flavor = "${flavor}";
  };
  gtk.enable = true;
  gtk.theme.name = "Catppuccin-Mocha-Standard-Pink-Dark";
  gtk.theme.package = (pkgs.catppuccin-gtk.override { accents = ["${accent}"]; variant = "${flavor}"; });
}

{ accent, flavor, ... }: {
  catppuccin = {
    accent = "${accent}";
    enable = true;
    flavor = "${flavor}";
  };
  gtk.enable = true;
}

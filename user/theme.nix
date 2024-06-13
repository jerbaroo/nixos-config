{ accent, flavor, pkgs, ... }: {
  catppuccin = {
    accent = "${accent}";
    enable = true;
    flavor = "${flavor}";
  };
  gtk.enable = true;
  gtk.font.name = "Atkinson Hyperlegible";
  gtk.font.package = pkgs.atkinson-hyperlegible;
  gtk.font.size = 16;
  # ls /etc/profiles/per-user/jer/share/icons
  gtk.iconTheme.name = "WhiteSur-dark";
  gtk.iconTheme.package = (pkgs.whitesur-icon-theme.override {
    alternativeIcons = true;
    boldPanelIcons = true;
  });
  # ls /etc/profiles/per-user/jer/share/icons
  home.pointerCursor = {
    gtk.enable = true;
    name = "Catppuccin-Mocha-Pink-Cursors";
    package = pkgs.catppuccin-cursors.mochaPink;
    x11.enable = true;
  };
  # ls /etc/profiles/per-user/jer/share/themes
  gtk.theme.name = "Catppuccin-Mocha-Standard-Pink-Dark";
  gtk.theme.package = (pkgs.catppuccin-gtk.override {
    accents = ["${accent}"]; variant = "${flavor}";
  });
}

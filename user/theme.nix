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
  catppuccin.gtk.icon.enable = false;
  gtk.iconTheme = {
    name = "WhiteSur-dark";
    package = (pkgs.whitesur-icon-theme.override {
      alternativeIcons = true;
      boldPanelIcons = true;
    });
  };
  # ls /etc/profiles/per-user/jer/share/icons
  catppuccin.cursors.enable = false;
  home.pointerCursor = {
    gtk.enable = true;
    name = "catppuccin-mocha-pink-cursors";
    package = pkgs.catppuccin-cursors.mochaPink;
    x11.enable = true;
  };
  # ls /etc/profiles/per-user/jer/share/themes
  gtk.theme.name = "catppuccin-mocha-pink-standard";
  gtk.theme.package = (pkgs.catppuccin-gtk.override {
    accents = ["${accent}"]; variant = "${flavor}";
  });
}

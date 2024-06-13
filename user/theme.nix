{ accent, flavor, pkgs, ... }: {
  catppuccin = {
    accent = "${accent}";
    enable = true;
    flavor = "${flavor}";
  };
  gtk.enable = true;
  # ls /etc/profiles/per-user/jer/share/themes
  gtk.theme.name = "Catppuccin-Mocha-Standard-Pink-Dark";
  gtk.theme.package = (pkgs.catppuccin-gtk.override {
    accents = ["${accent}"]; variant = "${flavor}";
  });
  # ls /etc/profiles/per-user/jer/share/icons
  gtk.iconTheme.name = "WhiteSur-dark";
  gtk.iconTheme.package = (pkgs.whitesur-icon-theme.override {
    alternativeIcons = true;
    boldPanelIcons = true;
  });
  # ls /etc/profiles/per-user/jer/share/icons
  home.pointerCursor = {
    gtk.enable = true;
    name = "oreo_pink_cursors";
    package = (pkgs.oreo-cursors-plus.override {
      cursorsConf = "pink = #f5c2e7";
    });
    x11.enable = true;
  };
}

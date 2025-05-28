{
  accent,
  flavor,
  pkgs,
  ...
}:
{
  catppuccin = {
    accent = "${accent}";
    enable = true;
    flavor = "${flavor}";
  };
  gtk.enable = true;

  # Font.
  gtk.font.name = "Atkinson Hyperlegible";
  gtk.font.package = pkgs.atkinson-hyperlegible;
  gtk.font.size = 16;

  # Icons.
  # ls /etc/profiles/per-user/jer/share/icons
  catppuccin.gtk.icon.enable = false;
  gtk.iconTheme = {
    name = "Oranchelo";
    package = pkgs.oranchelo-icon-theme;
  };

  # Cursors.
  # ls /etc/profiles/per-user/jer/share/icons
  catppuccin.cursors.enable = false;
  home.pointerCursor = {
    gtk.enable = true;
    name = "catppuccin-${flavor}-${accent}-cursors";
    package = pkgs.catppuccin-cursors."${flavor}${pkgs.lib.strings.toSentenceCase (accent)}";
    x11.enable = true;
  };

  # GTK Theme.
  # ls /etc/profiles/per-user/jer/share/themes
  gtk.theme.name = "catppuccin-${flavor}-${accent}-standard";
  gtk.theme.package = (
    pkgs.catppuccin-gtk.override {
      accents = [ "${accent}" ];
      variant = "${flavor}";
    }
  );
}

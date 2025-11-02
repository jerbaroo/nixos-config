{
  accent,
  ignis,
  palette,
  pkgs,
  ...
}:
{
  home.file.".config/ignis/colors.scss".text = ''
    $accent: ${palette.${accent}.hex};
    $base: ${palette.base.hex};
    $crust: ${palette.crust.hex};
    $mantle: ${palette.mantle.hex};
  '';
  programs.ignis = {
    enable = true;
    configDir = ./ignis;
    sass = {
      enable = true;
      useDartSass = true;
    };
    services = {
      audio.enable = true;
      # bluetooth.enable = true;
      # recorder.enable = true;
      # network.enable = true;
    };
    extraPackages = with pkgs; [
      libnotify
    ];
  };
}

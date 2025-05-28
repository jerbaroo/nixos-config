{
  accent,
  inputs,
  palette,
  pkgs,
  system,
  ...
}:
{
  home.file.".config/ignis/" = {
    source = ./ignis;
    recursive = true;
  };
  home.file.".config/ignis/colors.scss".text = ''
    $accent: ${palette.${accent}.hex};
    $base: ${palette.base.hex};
    $crust: ${palette.crust.hex};
    $mantle: ${palette.mantle.hex};
  '';
  home.packages = with pkgs; [
    inputs.ignis.packages.${system}.ignis
    libnotify
  ];
}

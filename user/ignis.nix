{ inputs, pkgs, system, ... }: {
  home.file.".config/ignis/" = {
    source = ./ignis;
    recursive = true;
  };
  home.packages = with pkgs; [
    inputs.ignis.packages.${system}.ignis
  ];
}

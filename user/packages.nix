{ pkgs, ... }:
{
  home.packages = with pkgs; [
    android-tools
    blueman
    dart
    dockfmt
    editorconfig-core-c
    fd
    feh
    jq
    libreoffice
    nixfmt-rfc-style
    obs-studio
    pandoc
    pavucontrol
    shellcheck
    shfmt
    texliveFull
    vlc
    zoom-us

    # Haskell
    cabal-install
    ghc
    haskell-language-server
    haskellPackages.hoogle

    # Python
    black
    isort
    pipenv
    python3
    python3Packages.pyflakes
    python3Packages.python-lsp-server
    python3Packages.pytest

    # Web/JS
    html-tidy
    nodePackages.js-beautify
    nodePackages.purs-tidy
    nodejs_24
    stylelint
  ];
}

{ pkgs, ... }:
{
  home.packages = with pkgs; [
    android-tools
    blueman
    dart
    dockfmt
    editorconfig-core-c
    fastfetch
    fd
    feh
    ffmpeg
    footage
    google-chrome
    grc
    jq
    htop
    libreoffice
    niv
    nixfmt-rfc-style
    obs-studio
    pandoc
    pavucontrol
    shellcheck
    shfmt
    spotify
    stack
    texliveFull
    unzip
    vlc
    wev
    wireguard-tools
    ydotool
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

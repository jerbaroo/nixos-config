{
  programs.neovim = {
    enable = true;
    extraConfig = ''
      :set clipboard=unnamedplus
      :set colorcolumn=80
      :set laststatus=0 ruler
    '';
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}

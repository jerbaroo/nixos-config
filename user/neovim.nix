{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    extraConfig = ''
      :set clipboard=unnamedplus
      :set colorcolumn=80
      :set laststatus=0 ruler
    '';
    extraLuaConfig = ''
      -- Home manager bug requires this line.
      vim.o.expandtab = true
      vim.o.shiftwidth = 2
      vim.o.softtabstop = 2
      vim.o.tabstop = 2
    '';
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}

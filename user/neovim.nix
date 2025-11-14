{ pkgs, ... }:
{
  programs.neovim = {
    defaultEditor = true;
    enable = true;
    extraLuaConfig = ''
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "

      vim.o.colorcolumn = "80"
      vim.o.clipboard="unnamedplus"
      vim.o.expandtab = true
      vim.o.shiftwidth = 2
      vim.o.softtabstop = 2
      vim.o.tabstop = 2

      local MiniBracketed = require("mini.bracketed")
      local MiniFiles = require("mini.files")
      local MiniPick = require("mini.pick")
      local builtIn = MiniPick.builtin

      vim.keymap.set("n", "<leader>.", function() MiniFiles.open() end, { desc = "List" })
      vim.keymap.set("n", "<leader>/", builtIn.grep_live, { desc = "Grep live" })
      vim.keymap.set("n", "<leader>bb", builtIn.buffers, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>bn", function() MiniBracketed.buffer("forward") end, { desc = "Next" })
      vim.keymap.set("n", "<leader>bp", function() MiniBracketed.buffer("backward") end, { desc = "Previous" })
      vim.keymap.set("n", "<leader>ff", builtIn.files, { desc = "Files" })
      vim.keymap.set("n", "<leader>fg", builtIn.grep_live, { desc = "Grep live" })
      vim.keymap.set("n", "<leader>fl", function() MiniFiles.open() end, { desc = "List" })
      vim.keymap.set("n", "<leader>fn", function() MiniBracketed.file("forward") end, { desc = "Next" })
      vim.keymap.set("n", "<leader>fp", function() MiniBracketed.file("backward") end, { desc = "Previous" })

      MiniBracketed.setup({})
      require('mini.clue').setup({
        triggers = { { mode = 'n', keys = '<Leader>' } },
        window = {
          config = {
            width = 'auto', -- Compute window width automatically
          },
          delay = 0, -- Show window immediately
          scroll_down = '<C-j>',
          scroll_down = '<C-k>',
        },
      })
      require("mini.comment").setup({})
      require("mini.completion").setup({})
      require("mini.diff").setup({})
      MiniFiles.setup({})
      require("mini.git").setup({})
      require("mini.icons").setup({})
      require("mini.notify").setup({})
      require("mini.pairs").setup({})
      MiniPick.setup({})
      require("mini.sessions").setup({})
      require("mini.statusline").setup({})
      require("mini.starter").setup({})
    '';
    package = pkgs.neovim-unwrapped;
    plugins = with pkgs.vimPlugins; [
      # catppuccin-nvim
      mini-nvim
      nvim-treesitter.withAllGrammars
      plenary-nvim
    ];
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}

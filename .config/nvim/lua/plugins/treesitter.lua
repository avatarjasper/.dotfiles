return {
  'nvim-treesitter/nvim-treesitter',  -- Treesitter plugin
  run = ':TSUpdate',  -- Automatically update treesitter after installation
  config = function()
    require('nvim-treesitter.configs').setup {
      ensure_installed = { "lua" },
      highlight = {
        enable = true,  -- Enable syntax highlighting
      },
    }
  end
}


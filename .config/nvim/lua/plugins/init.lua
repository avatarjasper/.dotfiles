return {
	
  { "kepano/flexoki-neovim", name = "flexoki", priority = 1000,
  config = function()
  	vim.cmd('colorscheme flexoki-dark') end },




--   { "catppuccin/nvim", name = "catppuccin", priority = 1000,
--   config = function()
--   	vim.cmd('colorscheme catppuccin-macchiato') end
-- },

-- {
  --   'folke/tokyonight.nvim',
  --   config = function()
  --     -- Enable the color scheme
  --     vim.cmd('colorscheme tokyonight')
  --   end
  -- },
  --
  require('plugins.treesitter'),

  -- LSP Config
  require('plugins.lspconfig'),

  -- Autocompletion
  require('plugins.completion'),

  -- FZF.vim
  require('plugins.fzf'),

  -- Which-Key
  require('plugins.whichkey'),

  -- mini icons
  require('plugins.mini'),  

  --minidev?
  { "nvim-tree/nvim-web-devicons", opts = {} },

  --startuptime
  require('plugins.startuptime'),

  {dir = '~/.config/nvim/lua/tab',
    name = "tab.lua",
lazy = false,
    dev = true,
  }

  }


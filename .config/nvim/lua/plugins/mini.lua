return {
  'echasnovski/mini.nvim',  -- mini.nvim plugin
  version = false,           -- Use the latest version
  config = function()
    -- Load the mini.icons module with default icons
    require('mini.icons').setup()
  end
}

return {
  -- Plugin specification
  'user/tab',  -- This should match your plugin's name
  -- Load the plugin on VimEnter
  event = "VimEnter",
  -- Configure the plugin
  config = function()
    -- Require and setup the plugin
    require("tab.tab").setup({
      -- You can customize the keymap here
      keymap = '<leader>hw'  -- Default keymap
    })
  end
} 
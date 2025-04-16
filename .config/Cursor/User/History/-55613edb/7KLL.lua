return {
  -- Plugin specification
  'user/tab',
  -- Load the plugin on VimEnter
  event = "VimEnter",
  -- Configure the plugin
  config = function()
    -- Require and setup the plugin
    require("tab.tab").setup()
  end
} 
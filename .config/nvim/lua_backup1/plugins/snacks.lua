return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	keys = {
		{
			"<leader>gg",
			function()
				require("snacks").lazygit()
			end,
			desc = "Open Lazygit",
		},
		{
			"<leader>.",
			function()
				require("snacks").scratch()
			end,
			desc = "Toggle Scratch Buffer",
		},
		{
			"<leader>S",
			function()
				require("snacks").scratch.select()
			end,
			desc = "Select Scratch Buffer",
		},
	},
	---@type snacks.Config
	opts = {
		indent = { enabled = true },
		input = { enabled = true },
		notifier = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = true },
		statuscolumn = { enabled = false }, -- we set this in options.lua
		words = { enabled = true },
		lazygit = {
			enabled = true,
			configure = true,
		},
		quickfile = { enabled = true },
		toggle = { enabled = true },
		scratch = {
			enabled = true,
		},

		dashboard = {
			preset = {
				header = [[
        :::   ::::::::  ::::::::::: :::::::::::
      :+:+:  :+:    :+: :+:     :+: :+:     :+:
       +:+  +:+    +:+        +:+         +:+  
      +#+   +#++:++#+       +#+         +#+    
     +#+         +#+      +#+         +#+      
    #+#  #+#    #+#     #+#         #+#        
 ####### ########      ###         ###         
]],
        -- stylua: ignore
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                  },
			},
		},
	},
	-- stylua: ignore
}

--
--
--       :::::::::::          :::        ::::::::  :::     ::: ::::::::::      ::::::::::: ::::::::  :::::::::  :::::::::::
--          :+:              :+:       :+:    :+: :+:     :+: :+:                 :+:    :+:    :+: :+:    :+:     :+:
--         +:+              +:+       +:+    +:+ +:+     +:+ +:+                 +:+    +:+    +:+ +:+    +:+     +:+
--        +#+              +#+       +#+    +:+ +#+     +:+ +#++:++#            +#+    +#+    +:+ +#++:++#:      +#+
--       +#+              +#+       +#+    +#+  +#+   +#+  +#+                 +#+    +#+    +#+ +#+    +#+     +#+
--      #+#              #+#       #+#    #+#   #+#+#+#   #+#                 #+#    #+#    #+# #+#    #+#     #+#
-- ###########          ########## ########      ###     ##########          ###     ########  ###    ### ###########

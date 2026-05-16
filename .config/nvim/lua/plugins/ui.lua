return {

	-- LUALINE (STATUS LINE)
	{
		"nvim-lualine/lualine.nvim",
		event = "VimEnter",

		init = function()
			-- Save original laststatus option
			vim.g.lualine_laststatus = vim.o.laststatus

			if vim.fn.argc(-1) > 0 then
				-- When opening files via command line, show empty statusline until lualine loads
				vim.o.statusline = " "
			else
				-- Otherwise, hide statusline on start screen (like dashboard)
				vim.o.laststatus = 0
			end
		end,

		config = function()
			-- Setup lualine_require (needed for lualine internals)
			local lualine_require = require("lualine_require")
			lualine_require.require = require

			-- Define icons yourself or require your own icon module here
			local icons = {
				diagnostics = {
					Error = " ",
					Warn = " ",
					Info = " ",
					Hint = " ",
				},
				git = {
					added = "+",
					modified = "~",
					removed = "-",
				},
			}

			-- Restore original laststatus value
			vim.o.laststatus = vim.g.lualine_laststatus

			require("lualine").setup({
				options = {
					theme = "auto",
					globalstatus = vim.o.laststatus == 3,
					disabled_filetypes = {
						statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" },
					},
				},

				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch" },

					lualine_c = {
						{
							"diagnostics",
							symbols = {
								error = icons.diagnostics.Error,
								warn = icons.diagnostics.Warn,
								info = icons.diagnostics.Info,
								hint = icons.diagnostics.Hint,
							},
						},
						{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
						-- { "filename", path = 1 }, -- show relative path
						{
							function()
								return vim.fn.expand("%:~:.") ~= "" and vim.fn.expand("%:~:.") or "[No Name]"
							end,
							color = { fg = "#82aaff", gui = "bold" }, -- gold color + bold
							icon = "󰈙 ", -- You can replace with any icon you like
						},
					},

					lualine_x = {
						-- noice status command
						{
							function()
								return package.loaded["noice"] and require("noice").api.status.command.get() or ""
							end,
							cond = function()
								return package.loaded["noice"] and require("noice").api.status.command.has()
							end,
							color = { fg = "#ff9e64" },
						},

						-- noice status mode
						{
							function()
								return package.loaded["noice"] and require("noice").api.status.mode.get() or ""
							end,
							cond = function()
								return package.loaded["noice"] and require("noice").api.status.mode.has()
							end,
							color = { fg = "#9ece6a" },
						},

						-- dap status
						{
							function()
								return package.loaded["dap"] and ("  " .. require("dap").status()) or ""
							end,
							cond = function()
								return package.loaded["dap"] and require("dap").status() ~= ""
							end,
							color = { fg = "#e0af68" },
						},

						-- lazy.nvim updates status
						{
							function()
								return require("lazy.status").updates()
							end,
							cond = require("lazy.status").has_updates,
							color = { fg = "#7dcfff" },
						},

						-- git diff symbols
						{
							"diff",
							symbols = {
								added = icons.git.added,
								modified = icons.git.modified,
								removed = icons.git.removed,
							},
							source = function()
								local gitsigns = vim.b.gitsigns_status_dict
								if gitsigns then
									return {
										added = gitsigns.added,
										modified = gitsigns.changed,
										removed = gitsigns.removed,
									}
								end
							end,
						},
					},

					lualine_y = {
						{ "progress", separator = " ", padding = { left = 1, right = 0 } },
						{ "location", padding = { left = 0, right = 1 } },
					},

					lualine_z = {
						function()
							return " " .. os.date("%R")
						end,
					},
				},

				extensions = { "lazy", "fzf" },
			})
		end,
	},

	-- NOTIFY
	{ "rcarriga/nvim-notify" },

	-- SMEAR CURSOR
	{
		"sphamba/smear-cursor.nvim",
		enabled = true,
		event = "VeryLazy",
		cond = vim.g.neovide == nil,
		opts = {
			cursor_color = "none",
			stiffness = 0.8, -- 0.6      [0, 1]
			trailing_stiffness = 0.5, -- 0.4      [0, 1]
			stiffness_insert_mode = 0.7, -- 0.5      [0, 1]
			trailing_stiffness_insert_mode = 0.7, -- 0.5      [0, 1]
			damping = 0.8, -- 0.65     [0, 1]
			damping_insert_mode = 0.8, -- 0.7      [0, 1]
			distance_stop_animating = 0.5, -- 0.1      > 0

			smear_insert_mode = false,
			smear_between_neighbor_lines = true,
			min_horizontal_distance_smear = 2,
			min_vertical_distance_smear = 0,
			smear_between_buffers = false,
			smear_to_cmd = false,
			time_interval = 7,
		},
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,

		---@type snacks.Config
		opts = {
			notifier = { enabled = true },
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
          { icon = " ", key = "f", desc = "Find File", action = ":Files ~" },
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
	},
}

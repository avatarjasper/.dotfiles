return {
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
					{ "filename", path = 1 }, -- show relative path
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

			extensions = { "neo-tree", "lazy", "fzf" },
		})
	end,
}

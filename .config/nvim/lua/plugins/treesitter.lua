return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" }, -- replace LazyFile with normal events
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		keys = {
			{ "<C-space>", desc = "Increment Selection" },
			{ "<BS>", desc = "Decrement Selection", mode = "x" },
		},
		opts = {
			highlight = { enable = true },
			indent = { enable = true },
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"javascript",
				"jsdoc",
				"json",
				"jsonc",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"printf",
				"python",
				"query",
				"regex",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"xml",
				"yaml",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<BS>",
				},
			},
			textobjects = {
				move = {
					enable = true,
					goto_next_start = {
						["]f"] = "@function.outer",
						["]c"] = "@class.outer",
						["]a"] = "@parameter.inner",
					},
					goto_next_end = {
						["]F"] = "@function.outer",
						["]C"] = "@class.outer",
						["]A"] = "@parameter.inner",
					},
					goto_previous_start = {
						["[f"] = "@function.outer",
						["[c"] = "@class.outer",
						["[a"] = "@parameter.inner",
					},
					goto_previous_end = {
						["[F"] = "@function.outer",
						["[C"] = "@class.outer",
						["[A"] = "@parameter.inner",
					},
				},
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		event = "VeryLazy", -- or BufReadPost, etc.
		config = function()
			-- Optional: prevent overriding c/C in diff mode
			local move = require("nvim-treesitter.textobjects.move")
			local configs = require("nvim-treesitter.configs")

			-- Patch movement handlers to fall back to default vim behavior in diff mode
			for name, fn in pairs(move) do
				if name:find("goto") == 1 then
					move[name] = function(query, ...)
						if vim.wo.diff then
							local config = configs.get_module("textobjects.move")[name] or {}
							for key, q in pairs(config) do
								if query == q and key:find("[%]%[][cC]") then
									vim.cmd.normal({ args = { key }, bang = true })
									return
								end
							end
						end
						return fn(query, ...)
					end
				end
			end
		end,
	},
}

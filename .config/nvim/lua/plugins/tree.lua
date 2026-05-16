return {
	{
		"stevearc/oil.nvim",
		-- enabled = true,
		enabled = false,
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},
		-- Optional dependencies
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
		-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
		lazy = false,
		keys = {
			{ "<leader>e", "<cmd>Oil<CR>", desc = "Open Oil File Explorer" },
			{
				"<leader>n",
				function()
					local oil = require("oil")
					local path = vim.fn.expand("%:p:h") -- gets directory of current file
					oil.open(path)
				end,
				desc = "Reveal Current File in Oil",
			},
		},
	},
	{
		"nvim-tree/nvim-tree.lua",
		enabled = false,
		-- enabled = true,
		lazy = false, -- load on startup; set true if you want lazy loading
		dependencies = {
			"nvim-tree/nvim-web-devicons", -- recommended for icons
		},
		opts = {
			disable_netrw = true,
			hijack_netrw = true,
			update_cwd = true,
			update_focused_file = {
				enable = true,
				update_cwd = true,
			},
			diagnostics = {
				enable = true,
				icons = {
					hint = "",
					info = "",
					warning = "",
					error = "",
				},
			},
			git = {
				enable = true,
				ignore = false,
				timeout = 400,
			},
			view = {
				width = 30,
				side = "left",
			},
		},
		keys = {
			{
				"<leader>fe",
				function()
					require("nvim-tree.api").tree.toggle({ find_file = false, focus = false })
				end,
				desc = "Toggle NvimTree Explorer (Root Dir)",
			},
			{
				"<leader>fE",
				function()
					require("nvim-tree.api").tree.toggle({ find_file = true, focus = false })
				end,
				desc = "Toggle NvimTree Explorer (Focus on current file)",
			},
			{
				"<leader>e",
				function()
					require("nvim-tree.api").tree.toggle({ find_file = false, focus = false })
				end,
				desc = "Toggle NvimTree Explorer (Root Dir)",
			},
			{
				"<leader>E",
				function()
					require("nvim-tree.api").tree.toggle({ find_file = true, focus = false })
				end,
				desc = "Toggle NvimTree Explorer (cwd)",
			},

			{
				"<leader>n",

				function()
					require("nvim-tree.api").tree.focus()
					require("nvim-tree.api").tree.find_file({ open = true })
				end,
				desc = "Reveal current file in NvimTree",
			},
		},
	},

	{
		"echasnovski/mini.files",
		enabled = false,
		version = false,
		keys = {
			{ "<leader>e", "<cmd>lua MiniFiles.open()<CR>", desc = "Open Oil File Explorer" },
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		enabled = true,
		cmd = "Neotree",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons", -- optional, but recommended
		},
		lazy = false, -- neo-tree will lazily load itself
		keys = {
			{
				"<leader>fe",
				function()
					require("neo-tree.command").execute({ toggle = true })
				end,
				desc = "Explorer NeoTree (Root Dir)",
			},
			{
				"<leader>fE",
				function()
					require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
				end,
				desc = "Explorer NeoTree (cwd)",
			},
			{ "<leader>e", "<leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
			{ "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
			{
				"<leader>ge",
				function()
					require("neo-tree.command").execute({ source = "git_status", toggle = true })
				end,
				desc = "Git Explorer",
			},
			{
				"<leader>be",
				function()
					require("neo-tree.command").execute({ source = "buffers", toggle = true })
				end,
				desc = "Buffer Explorer",
			},
			{
				"<leader>n",
				function()
					vim.cmd("Neotree filesystem reveal left")
				end,
				desc = "Reveal Neo-tree on the left",
			},
		},
		deactivate = function()
			vim.cmd([[Neotree close]])
		end,
		init = function()
			-- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
			-- because `cwd` is not set up properly.
			vim.api.nvim_create_autocmd("BufEnter", {
				group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
				desc = "Start Neo-tree with directory",
				once = true,
				callback = function()
					if package.loaded["neo-tree"] then
						return
					else
						local stats = vim.uv.fs_stat(vim.fn.argv(0))
						if stats and stats.type == "directory" then
							require("neo-tree")
						end
					end
				end,
			})
		end,
		opts = {
			sources = { "filesystem", "buffers", "git_status" },
			open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
			filesystem = {
				bind_to_cwd = true,
				follow_current_file = { enabled = false },
				use_libuv_file_watcher = true,
				filtered_items = {
					visible = true,
					hite_dotfiles = false,
				},
			},
			window = {
				mappings = {
					["l"] = "open",
					["h"] = "close_node",
					["<space>"] = "none",
					["Y"] = {
						function(state)
							local node = state.tree:get_node()
							local path = node:get_id()
							vim.fn.setreg("+", path, "c")
						end,
						desc = "Copy Path to Clipboard",
					},
					["O"] = {
						function(state)
							require("lazy.util").open(state.tree:get_node().path, { system = true })
						end,
						desc = "Open with System Application",
					},
					["P"] = { "toggle_preview", config = { use_float = false } },
				},
			},
			default_component_configs = {
				indent = {
					with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
				},
				git_status = {
					symbols = {
						unstaged = "󰄱",
						staged = "󰱒",
					},
				},
			},
		},
		config = function(_, opts)
			local function on_move(data)
				Snacks.rename.on_rename_file(data.source, data.destination)
			end

			local events = require("neo-tree.events")
			opts.event_handlers = opts.event_handlers or {}
			vim.list_extend(opts.event_handlers, {
				{ event = events.FILE_MOVED, handler = on_move },
				{ event = events.FILE_RENAMED, handler = on_move },
			})
			require("neo-tree").setup(opts)
			vim.api.nvim_create_autocmd("TermClose", {
				pattern = "*lazygit",
				callback = function()
					if package.loaded["neo-tree.sources.git_status"] then
						require("neo-tree.sources.git_status").refresh()
					end
				end,
			})
		end,
	},
}

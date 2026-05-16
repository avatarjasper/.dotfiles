return {
	{
		"junegunn/fzf.vim", -- Fuzzy finder plugin
		enabled = true,
		dependencies = { "junegunn/fzf" },
		build = ":fzf#install", -- Run the installation command (optional)
		config = function()
			-- local map = vim.api.nvim_set_keymap
			-- local opts = { noremap = true, silent = true }

			-- map("n", "<Leader>ff", ":Files<CR>", opts)
			-- map("n", "<Leader>fg", ":GFiles<CR>", opts)
			-- map("n", "<Leader>fb", ":Buffers<CR>", opts)
			-- map("n", "<Leader>fh", ":Helptags<CR>", opts)
			-- map("n", "<Leader>fr", ":Rg<CR>", opts)
			-- map("n", "<Leader>fo", ":History<CR>", opts)
		end,
	},
	{
		"ibhagwan/fzf-lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"echasnovski/mini.icons",
		},
		opts = {},
		config = function()
			vim.keymap.set("n", "<leader>fp", function()
				local dirs = {}

				for dir in vim.fs.parents(vim.uv.cwd()) do
					table.insert(dirs, dir)
				end

				require("fzf-lua").fzf_exec(dirs, {
					prompt = "Parent Directories❯ ",
					actions = {
						["default"] = function(selected)
							require("fzf-lua").files({ cwd = selected[1] })
						end,
					},
				})
			end, { desc = "[S]earch Parent Directories [..]" })
		end,
	},

	{
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

		keys = {
			{ "<c-j>", "<c-j>", ft = "fzf", mode = "t", nowait = true },
			{ "<c-k>", "<c-k>", ft = "fzf", mode = "t", nowait = true },
			{
				"<leader>,",
				"<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>",
				desc = "Switch Buffer",
			},
			{ "<leader>/", "<cmd>FzfLua live_grep<cr>", desc = "Grep (Root Dir)" },
			{ "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
			{ "<leader><space>", "<cmd>:lua Snacks.picker('files')<cr>", desc = "Find Files (Root Dir)" },
			-- find
			{ "<leader>fb", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
			{ "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Fzfind Files (Root Dir)" },
			{
				"<leader>fF",
				function()
					require("fzf-lua").files({ cwd = vim.fn.getcwd(-1, -1) })
				end,
				desc = "Fzfind Files (Startup Dir)",
			},

			{ "<leader>F", "<cmd>Files ~<cr>", desc = "FZFind HOME" },
			{ "<leader>fg", "<cmd>FzfLua git_files<cr>", desc = "Find Files (git-files)" },
			{ "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent" },
			-- git
			{ "<leader>gc", "<cmd>FzfLua git_commits<CR>", desc = "Commits" },
			{ "<leader>gs", "<cmd>FzfLua git_status<CR>", desc = "Status" },
			-- search
			{ '<leader>s"', "<cmd>FzfLua registers<cr>", desc = "Registers" },
			{ "<leader>sa", "<cmd>FzfLua autocmds<cr>", desc = "Auto Commands" },
			{ "<leader>sb", "<cmd>FzfLua grep_curbuf<cr>", desc = "Buffer" },
			{ "<leader>sc", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
			{ "<leader>sC", "<cmd>FzfLua commands<cr>", desc = "Commands" },
			{ "<leader>sd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Document Diagnostics" },
			{ "<leader>sD", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Workspace Diagnostics" },
			{ "<leader>sg", "<cmd>FzfLua live_grep<cr>", desc = "Grep (Root Dir)" },
			{ "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "Help Pages" },
			{ "<leader>sH", "<cmd>FzfLua highlights<cr>", desc = "Search Highlight Groups" },
			{ "<leader>sj", "<cmd>FzfLua jumps<cr>", desc = "Jumplist" },
			{ "<leader>sk", "<cmd>FzfLua keymaps<cr>", desc = "Key Maps" },
			{ "<leader>sl", "<cmd>FzfLua loclist<cr>", desc = "Location List" },
			{ "<leader>sM", "<cmd>FzfLua man_pages<cr>", desc = "Man Pages" },
			{ "<leader>sm", "<cmd>FzfLua marks<cr>", desc = "Jump to Mark" },
			{ "<leader>sR", "<cmd>FzfLua resume<cr>", desc = "Resume" },
			{ "<leader>sq", "<cmd>FzfLua quickfix<cr>", desc = "Quickfix List" },
			{ "<leader>sw", "<cmd>FzfLua grep_cword<cr>", desc = "Word" },
			{ "<leader>sw", "<cmd>FzfLua grep_visual<cr>", mode = "v", desc = "Selection (Root Dir)" },
			{ "<leader>uC", "<cmd>FzfLua colorschemes<cr>", desc = "Colorscheme with Preview" },
			{
				"<leader>ss",
				function()
					require("fzf-lua").lsp_document_symbols({
						regex_filter = symbols_filter,
					})
				end,
				desc = "Goto Symbol",
			},
			{
				"<leader>sS",
				function()
					require("fzf-lua").lsp_live_workspace_symbols({
						regex_filter = symbols_filter,
					})
				end,
				desc = "Goto Symbol (Workspace)",
			},
		},
		---@type snacks.Config
		opts = {
			lazygit = {
				enabled = true,
				configure = true,
			},
			picker = {
				enabled = true,
			},
		},
		-- stylua: ignore
	},
}

return {
	"junegunn/fzf.vim", -- Fuzzy finder plugin
	dependencies = { "junegunn/fzf" },
	build = ":fzf#install", -- Run the installation command (optional)
	config = function()
		local map = vim.api.nvim_set_keymap
		local opts = { noremap = true, silent = true }

		map("n", "<Leader>ff", ":Files<CR>", opts)
		map("n", "<Leader>fg", ":GFiles<CR>", opts)
		map("n", "<Leader>fb", ":Buffers<CR>", opts)
		map("n", "<Leader>fh", ":Helptags<CR>", opts)
		map("n", "<Leader>fr", ":Rg<CR>", opts)
		map("n", "<Leader>fo", ":History<CR>", opts)
	end,
}
--
--
-- return {
-- 	"ibhagwan/fzf-lua",
-- 	-- optional for icon support
-- 	dependencies = { "nvim-tree/nvim-web-devicons" },
-- 	-- or if using mini.icons/mini.nvim
-- 	-- dependencies = { "echasnovski/mini.icons" },
-- 	opts = {},
-- }

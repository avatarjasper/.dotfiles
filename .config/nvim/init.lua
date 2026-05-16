-- init.lua

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- Load the lazy.nvim setup
require("config.lazy")

-- TODO: help me work better
--
-- OIL
-- require("oil").setup()
-- function _G.get_oil_winbar()
-- 	local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
-- 	local dir = require("oil").get_current_dir(bufnr)
-- 	if dir then
-- 		return vim.fn.fnamemodify(dir, ":~")
-- 	else
-- 		-- If there is no current directory (e.g. over ssh), just show the buffer name
-- 		return vim.api.nvim_buf_get_name(0)
-- 	end
-- end

-- require("oil").setup({
-- 	win_options = {
-- 		winbar = "%!v:lua.get_oil_winbar()",
-- 	},
-- })

-- require("mini.files").setup()

-- Optionally, set up basic settings for Neovim here
vim.opt.number = true -- Example: Enable line numbers
vim.opt.relativenumber = true -- Example: Enable relative line numbers
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.scrolloff = 5
-- fzf.vim keybindings
-- vim.api.nvim_set_keymap("n", "<Leader>ff", ":Files<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<Leader>fg", ":GFiles<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<Leader>fb", ":Buffers<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<Leader>fh", ":Helptags<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<Leader>fr", ":Rg<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<Leader>fo", ":History<CR>", { noremap = true, silent = true })
--
vim.api.nvim_set_keymap("n", "<C-k>", ":wincmd k<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", ":wincmd j<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-h>", ":wincmd h<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-l>", ":wincmd l<CR>", { noremap = true, silent = true })

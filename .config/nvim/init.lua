-- init.lua

-- Load the lazy.nvim setup
require('config.lazy')

-- Optionally, set up basic settings for Neovim here
vim.opt.number = true  -- Example: Enable line numbers
vim.opt.relativenumber = true  -- Example: Enable relative line numbers

-- fzf.vim keybindings
vim.api.nvim_set_keymap('n', '<Leader>ff', ':Files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fg', ':GFiles<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fb', ':Buffers<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fh', ':Helptags<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fr', ':Rg<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<C-k>', ':wincmd k<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', ':wincmd j<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-h>', ':wincmd h<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', ':wincmd l<CR>', { noremap = true, silent = true })

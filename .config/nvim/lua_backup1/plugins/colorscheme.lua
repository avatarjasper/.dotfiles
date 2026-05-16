--return { "kepano/flexoki-neovim", name = "flexoki", priority = 1000,
-- config = function()
--	vim.cmd('colorscheme flexoki-dark') end }

return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	opts = { style = "moon" },
	config = function()
		vim.cmd("colorscheme tokyonight")
	end,
}

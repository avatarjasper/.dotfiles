return {
  'neovim/nvim-lspconfig',  -- LSP plugin
  event = 'LspAttach',  -- Load when opening a buffer
  config = function()
	  local lspconfig = require('lspconfig')
    -- Example LSP setup (Pyright for Python)
	--require('lspconfig').pyright.setup{}
	vim.diagnostic.config({
	    virtual_text = true,
        signs = true,
        update_in_insert = true,
        underline = true,})
	lspconfig.pyright.setup{}

	lspconfig.clangd.setup{}

	--lspconfig.cmake.setup{}

end
}

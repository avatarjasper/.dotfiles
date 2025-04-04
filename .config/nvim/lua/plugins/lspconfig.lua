return {
  'neovim/nvim-lspconfig',  -- LSP plugin
  event = 'BufRead',  -- Load when opening a buffer
  config = function()
    -- Example LSP setup (Pyright for Python)
    require('lspconfig').pyright.setup{}
  end
}

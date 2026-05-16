return {
	{
		"mason-org/mason.nvim",
		config = function()
			-- Mason Setup
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓", -- Icon for installed packages
						package_pending = "➜", -- Icon for pending packages
						package_uninstalled = "✗", -- Icon for uninstalled packages
					},
				},
			})

			--     })
		end,
	},
	{ { "williamboman/mason-lspconfig.nvim" } },
}

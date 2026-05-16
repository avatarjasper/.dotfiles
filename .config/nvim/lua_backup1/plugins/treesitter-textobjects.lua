return {
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
}

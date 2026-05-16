return {
	"HakonHarnes/img-clip.nvim",
	event = "VeryLazy",
	opts = {
		dir_path = "~/Documents/Thesis/overleaf/literature_study_git/figures/LiteratureStudy/",
		use_absolute_path = true,
	},
	keys = {
		-- suggested keymap
		{ "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
	},
}

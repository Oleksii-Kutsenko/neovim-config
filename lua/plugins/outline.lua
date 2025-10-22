return {
	"hedyhli/outline.nvim",
	lazy = true,
	cmd = { "Outline", "OutlineOpen" },
	keys = {
		{ "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
	},
	opts = {
		symbols = {
			filter = { "Variable", exclude = true },
		},
		symbol_folding = {
			autofold_depth = 1,
			auto_unfold = {
				hovered = true,
			},
		},
	},
}

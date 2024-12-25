return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	keys = {},
	config = function()
		require("nvim-tree").setup({
			sync_root_with_cwd = true,
		})

		local wk = require("which-key")
		wk.add({
			{ "<leader>e", "<cmd>NvimTreeFocus<cr>", desc = "Explorer" },
		})
	end,
}

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
			{ "<leader>e", group = "Explorer" },
			{ "<leader>ee", ":NvimTreeToggle<CR>", desc = "Toggle file explorer" },
			{ "<leader>er", "<cmd>NvimTreeFocus<cr>", desc = "Toggle focus to file explorer" },
			{ "<leader>ef", ":NvimTreeFindFile<CR>", desc = "Find file in file explorer" },
		})
	end,
}

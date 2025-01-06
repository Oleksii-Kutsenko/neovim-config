return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "VeryLazy" },
	keys = {
		{ "<c-space>", desc = "Increment Selection" },
		{ "<bs>", desc = "Decrement Selection", mode = "x" },
	},
	opts = {
		ensure_installed = {
			"c",
			"lua",
			"vim",
			"vimdoc",
			"elixir",
			"javascript",
			"html",
			"python",
			"typescript",
		},
		sync_install = false,
		highlight = { enable = true },
		indent = { enable = true },
		auto_install = true,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<C-space>",
			node_incremental = "<C-space>",
			scope_incremental = false,
			node_decremental = "<bs>",
		},
	},
	config = function(_, opts)
		local configs = require("nvim-treesitter.configs")
		configs.setup(opts)
	end,
}

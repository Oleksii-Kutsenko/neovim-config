return {
	"natecraddock/workspaces.nvim",
	config = function()
		require("workspaces").setup()
	end,
	lazy = false,
	keys = {
		{
			"<C-p>",
			":Telescope workspaces<CR>",
			mode = "n",
			desc = "Open projects list",
		},
	},
}

return {
	"RRethy/vim-illuminate",
	config = function()
		vim.g.Illuminate_delay = 100
		vim.g.Illuminate_ftblacklist = { "NvimTree", "TelescopePrompt" }
		vim.g.Illuminate_highlightUnderCursor = 0

		local wk = require("which-key")

		wk.add({
			{
				"<leader>n",
				function()
					require("illuminate").next_reference({ wrap = true })
				end,
				desc = "Next reference",
			},
			{
				"<leader>p",
				function()
					require("illuminate").next_reference({ reverse = true, wrap = true })
				end,
				desc = "Previous reference",
			},
		})
	end,
}

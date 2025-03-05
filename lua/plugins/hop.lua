return {
	"smoka7/hop.nvim",
	version = "*",
	config = function()
		local hop = require("hop")
		local directions = require("hop.hint").HintDirection
		local wk = require("which-key")

		hop.setup({
			keys = "etovxqpdygfblzhckisuran", -- You can adjust the keys string as needed
		})

		-- Add hop keymaps to which-key
		wk.add({
			{
				"<leader>f",
				function()
					hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = false })
				end,
				desc = "Hop to character forward",
			},
			{
				"<leader>F",
				function()
					hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = false })
				end,
				desc = "Hop to character backward",
			},
		}, { prefix = "", mode = "n" })
	end,
}

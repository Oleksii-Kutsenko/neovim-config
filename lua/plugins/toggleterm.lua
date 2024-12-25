return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			-- Size can be a number or a function that calculates the terminal size
			size = function(term)
				if term.direction == "horizontal" then
					return 15
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.4
				end
				return 20 -- Default size
			end,
			open_mapping = [[<c-\>]], -- Example default mapping
			hide_numbers = true, -- Hide number column in terminal buffers
			shade_filetypes = {},
			shade_terminals = true,
			shading_factor = 2, -- The degree of shading for terminal
			start_in_insert = true,
			persist_size = true,
			direction = "horizontal", -- Default direction: horizontal, vertical, float
			close_on_exit = true, -- Close terminal when process exits
			shell = "pwsh.exe",
		})
		vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
	end,
}

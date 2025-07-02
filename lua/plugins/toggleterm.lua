-- Terminal key mappings
function set_terminal_keymaps()
	local opts = { buffer = 0 }
	vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
	vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
	vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
	vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
	vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
	vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
	vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

local in_wsl = vim.fn.has("wsl") == 1 or vim.env.WSL_DISTRO_NAME ~= nil
local default_shell = in_wsl and "/bin/bash -l" or "pwsh.exe"

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
			shell = default_shell,
			on_open = function()
				set_terminal_keymaps()
			end,
		})
		vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
	end,
}

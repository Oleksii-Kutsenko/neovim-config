-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.clipboard = "unnamedplus" -- use system keyboard for yank

vim.opt.nu = true -- set line numbers -- set line numbers
vim.opt.relativenumber = true -- use relative line numbers

-- Lazy.nvim setup
require("lazy").setup({
	spec = {
		-- Import your plugins
		{ import = "plugins" },
	},
	install = {},
	checker = { enabled = true },
})

-- Terminal key mappings
function _G.set_terminal_keymaps()
	local opts = { buffer = 0 }
	vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
	vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
	vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
	vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
	vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
	vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
	vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

-- Commands to enable or disable formatting
vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		vim.b.disable_autoformat = true
	else
		vim.g.disable_autoformat = true
	end
end, {
	desc = "Disable autoformat-on-save",
	bang = true,
})

vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, {
	desc = "Re-enable autoformat-on-save",
})

vim.cmd.colorscheme("catppuccin-latte")

local function get_python_path_for_project()
	-- Check if the project has a `.python-version` file
	local project_root = vim.fn.getcwd()
	local python_version_file = project_root .. "\\.python-version"

	-- If the `.python-version` file exists, use pyenv to get the python path for that version
	if vim.fn.filereadable(python_version_file) == 1 then
		local version = vim.fn.trim(vim.fn.readfile(python_version_file)[1])
		local python_path = vim.fn.trim(vim.fn.system("pyenv which python@" .. version))

		if vim.fn.executable(python_path) == 1 then
			return python_path
		end
	end

	-- Default Python executable if no .python-version file is found
	return vim.fn.trim(vim.fn.system("pyenv which python"))
end

local python_host_prog = get_python_path_for_project()

if vim.fn.has("win32") == 1 then
	-- Convert Unix-style paths to Windows-style paths
	python_host_prog = python_host_prog:gsub("/", "\\")
end

vim.g.python3_host_prog = python_host_prog

print("Python3 host program set to: " .. vim.g.python3_host_prog)

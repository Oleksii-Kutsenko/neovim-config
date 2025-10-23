local opt = vim.opt

opt.clipboard = "unnamedplus" -- use system keyboard for yank
opt.completeopt = { "menu", "menuone" }

-- Tab
opt.tabstop = 4
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- UI config
opt.nu = true -- set line numbers -- set line numbers
opt.relativenumber = true -- use relative line numbers

-- Folds
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldcolumn = "0"
opt.foldtext = ""
opt.foldlevel = 99
opt.foldlevelstart = 4
opt.foldnestmax = 4

-- Searching
opt.incsearch = true -- search as characters are entered
opt.hlsearch = false -- do not highlight matches
opt.ignorecase = true -- ignore case in searches by default
opt.smartcase = true -- but make it case sensitive if an uppercase is entered

vim.filetype.add({
	extension = {
		html = "htmldjango",
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "htmldjango",
	callback = function()
		vim.opt.shiftwidth = 4
		vim.opt.tabstop = 4
		vim.opt.smartindent = false
		vim.opt.autoindent = false
	end,
})

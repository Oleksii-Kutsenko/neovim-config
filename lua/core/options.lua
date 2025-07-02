local opt = vim.opt

opt.autoindent = true
opt.smartindent = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2

opt.nu = true -- set line numbers -- set line numbers
opt.relativenumber = true -- use relative line numbers

opt.clipboard = "unnamedplus" -- use system keyboard for yank

opt.ignorecase = true
opt.smartcase = true

opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldcolumn = "0"
opt.foldtext = ""
opt.foldlevel = 99
opt.foldlevelstart = 3
opt.foldnestmax = 4

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

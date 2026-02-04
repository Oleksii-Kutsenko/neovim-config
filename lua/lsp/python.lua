vim.g.python3_host_prog = vim.fn.expand("~/.neovim-venv/bin/python")

vim.lsp.config("ty", {
	cmd = { "ty", "server" },
	filetypes = { "python" },
	root_markers = { "ty.toml", "pyproject.toml", ".git" },
})
vim.lsp.enable({ "ty" })

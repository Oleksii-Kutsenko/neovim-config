return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"mfussenegger/nvim-lint",
	},
	config = function()
		require("mason").setup()
		local mason_lspconfig = require("mason-lspconfig")
		mason_lspconfig.setup({})

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

		local pyright_config = require("lsp.pyright")
		pyright_config.setup()

		require("lspconfig").eslint.setup({
			settings = {
				packageManager = "yarn",
			},
			on_attach = function(client, bufnr)
				vim.api.nvim_create_autocmd("BufWritePre", {
					buffer = bufnr,
					command = "EslintFixAll",
				})
			end,
		})

		local lint = require("lint")
		lint.linters.pylint.cmd = { "pylint", "--output-format", "json", "--reports", "no" }
		lint.linters.mypy.cmd = { "mypy" }

		vim.cmd([[autocmd BufWritePost *.py lua require('lint').try_lint()]])
	end,
}

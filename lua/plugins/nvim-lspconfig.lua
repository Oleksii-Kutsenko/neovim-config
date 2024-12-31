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
		mason_lspconfig.setup({
			ensure_installed = { "pyright", "pylint", "mypy" },
		})

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

		local pyright_config = require("lsp.pyright")
		pyright_config.setup()

		require("lspconfig").pyright.setup({
			capabilities = capabilities,
		})

		local lint = require("lint")

		lint.linters.pylint.cmd = { "pylint", "--output-format", "json", "--reports", "no" }
		lint.linters.mypy.cmd = { "mypy" }

		vim.cmd([[autocmd BufWritePost *.py lua require('lint').try_lint()]])
	end,
	opts = {
		servers = {
			pyright = {
				settings = {
					pyright = {
						analysis = {
							typeCheckingMode = "off",
							diagnosticMode = "off",
						},
					},
				},
			},
		},
	},
}

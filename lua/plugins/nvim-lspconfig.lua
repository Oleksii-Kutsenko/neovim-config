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
			ensure_installed = { "pylsp" },
		})

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

		require("lspconfig").pylsp.setup({
			capabilities = capabilities,
			settings = {
				pylsp = {
					plugins = {
						-- formatters
						black = { enabled = true },
						-- linters
						pylint = { enabled = true },
						pycodestyle = { enabled = true },
						-- type checker
						pylsp_mypy = { enabled = true },
						-- auto-completion options
						jedi_completion = { fuzzy = true },
						-- import sorting
						pyls_isort = { enabled = true },
					},
				},
			},
			flags = {
				debounce_text_changes = 200,
			},
		})

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
	end,
}

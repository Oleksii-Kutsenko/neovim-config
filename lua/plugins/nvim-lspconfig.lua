return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		require("mason").setup()
		local mason_lspconfig = require("mason-lspconfig")
		mason_lspconfig.setup({
			ensure_installed = { "pyright" },
		})

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

		local pyright_config = require("lsp.pyright")
		pyright_config.setup()

		require("lspconfig").pyright.setup({
			capabilities = capabilities,
		})
	end,
	opts = {
		servers = {
			pyright = {
				settings = {
					pyright = {
						analysis = {
							typeCheckingMode = "standard",
							diagnosticMode = "off",
						},
					},
				},
			},
		},
	},
}

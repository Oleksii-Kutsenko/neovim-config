return {
	"neovim/nvim-lspconfig",
	event = "VeryLazy",
	dependencies = {
		"williamboman/mason.nvim",
		{ "williamboman/mason-lspconfig.nvim" },
		{ "WhoIsSethDaniel/mason-tool-installer.nvim" }, -- Auto-installer for linters/formatters
		"hrsh7th/cmp-nvim-lsp",
		{ "j-hui/fidget.nvim", opts = {} }, -- LSP progress indicator
	},
	config = function()
		local util = require("lspconfig.util")

		require("mason").setup()
		require("mason-tool-installer").setup({
			ensure_installed = {
				"vue_ls",
				"pyright",
				"eslint",
			},
		})

		local servers = {
			djlsp = {
				cmd = { "djlsp" },
				filetypes = { "html", "htmldjango" },
				init_options = {
					djlsp = {},
				},
			},
			pyright = require("lsp.pyright"),
			eslint = {
				settings = {
					packageManager = "yarn",
				},
				on_attach = function(client, bufnr)
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						command = "EslintFixAll",
					})
				end,
			},
		}

		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		require("mason-lspconfig").setup({
			ensure_installed = {"pyright", "eslint"},
		})

		for server_name, server_config in pairs(servers) do
			local opts = vim.tbl_deep_extend("force", {}, server_config)
			opts.capabilities = vim.tbl_deep_extend("force", opts.capabilities or {}, capabilities)
			require("lspconfig")[server_name].setup(opts)
		end
	end,
}

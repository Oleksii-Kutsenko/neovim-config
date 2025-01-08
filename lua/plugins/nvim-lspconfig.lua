return {
	"neovim/nvim-lspconfig",
	event = "VeryLazy",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		-- Auto-Install LSPs, linters, formatters, debuggers
		-- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
		{ "WhoIsSethDaniel/mason-tool-installer.nvim" },

		"hrsh7th/cmp-nvim-lsp",
		{ "j-hui/fidget.nvim", opts = {} },
	},
	config = function()
		require("mason").setup()
		local mason_lspconfig = require("mason-lspconfig")
		mason_lspconfig.setup({
			ensure_installed = {
				pyright,
			},
		})

		require("mason-tool-installer").setup({
			-- Install these linters, formatters, debuggers automatically
			ensure_installed = {
				"black",
				"isort",
				"mypy",
				"pylint",
			},
		})

		local lspconfig = require("lspconfig")
		local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
		local lsp_attach = function(client, bufnr)
			-- Create your keybindings here...
		end

		-- Call setup on each LSP server
		require("mason-lspconfig").setup_handlers({
			function(server_name)
				lspconfig[server_name].setup({
					on_attach = lsp_attach,
					capabilities = lsp_capabilities,
				})
			end,
		})

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

		local wk = require("which-key")

		wk.add({
			{ "<leader>g", group = "LSP" },
			{ "<leader>gg", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "Show hover information" },
			{ "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>", desc = "Go to definition" },
			{ "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", desc = "Go to declaration" },
			{ "<leader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", desc = "Go to implementation" },
			{ "<leader>gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", desc = "Go to type definition" },
			{ "<leader>gr", "<cmd>lua vim.lsp.buf.references()<CR>", desc = "Find references" },
			{ "<leader>gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", desc = "Show signature help" },
			{
				"<leader>gf",
				"<cmd>lua vim.lsp.buf.format({async = true})<CR>",
				desc = "Format code",
				mode = { "n", "v" },
			},
			{ "<leader>ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "Show code actions" },
			{ "<leader>gl", "<cmd>lua vim.diagnostic.open_float()<CR>", desc = "Show diagnostics in floating window" },
			{ "<leader>gp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", desc = "Go to previous diagnostic" },
			{ "<leader>gn", "<cmd>lua vim.diagnostic.goto_next()<CR>", desc = "Go to next diagnostic" },
			{ "<leader>tr", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", desc = "List document symbols" },
			{ "<leader>r", group = "Refactor" },
			{ "<leader>rr", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "Rename symbol" },
			{ "<C-Space>", "<cmd>lua vim.lsp.buf.completion()<CR>", desc = "Trigger completion", mode = "i" },
		})
	end,
}

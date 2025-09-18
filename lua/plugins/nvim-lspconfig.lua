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
				"pylsp",
				"ruff",
				"pylint",
				"mypy",
				"djlint",
				"eslint",
				"vue-language-server",
				"prettierd",
				"stylua",
			},
		})

		local on_attach = function(client, bufnr)
			vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

			local wk = require("which-key")
			wk.add({
				mode = { "n", "v" },
				buffer = bufnr,
				{ "<leader>g", group = "LSP" },
				{ "<leader>gg", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "Hover" },
				{ "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>", desc = "Definition" },
				{ "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", desc = "Declaration" },
				{ "<leader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", desc = "Implementation" },
				{ "<leader>gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", desc = "Type Definition" },
				{ "<leader>gr", "<cmd>lua vim.lsp.buf.references()<CR>", desc = "References" },
				{ "<leader>gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", desc = "Signature Help" },
				{ "<leader>ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "Code Action" },
				{ "<leader>gl", "<cmd>lua vim.diagnostic.open_float()<CR>", desc = "Line Diagnostics" },
				{ "<leader>gp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", desc = "Prev Diagnostic" },
				{ "<leader>gn", "<cmd>lua vim.diagnostic.goto_next()<CR>", desc = "Next Diagnostic" },
				{ "<leader>rr", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "Rename" },
			})
		end

		local lspconfig = require("lspconfig")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		local servers = {
			djlsp = {
				cmd = { "djlsp" },
				filetypes = { "html", "htmldjango" },
				init_options = {
					djlsp = {},
				},
			},
			pylsp = {
				cmd = { "pylsp" },
				filetypes = { "python" },
				root_markers = {
					"pyproject.toml",
					"setup.py",
					"setup.cfg",
					"requirements.txt",
					"Pipfile",
					".git",
				},
				settings = {
					pylsp = {
						plugins = {
							ruff = { enabled = true, format = {} },
							-- pylint = { enabled = true, args = { "--recursive=y" } },
							mypy = { enabled = true, live_mode = true },
							pyflakes = { enabled = false },
							mccabe = { enabled = false },
							pycodestyle = { enabled = false },
							rope_autoimport = {
								enabled = true,
								{ completions = { enabled = true } },
							},
						},
					},
				},
			},
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

		for server_name, server_config in pairs(servers) do
			local final_config = vim.tbl_deep_extend("force", {
				on_attach = on_attach,
				capabilities = capabilities,
			}, server_config)
			lspconfig[server_name].setup(final_config)
		end
	end,
}

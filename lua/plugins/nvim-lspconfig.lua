return {
	"neovim/nvim-lspconfig",
	event = "VeryLazy",
	dependencies = {
		"williamboman/mason.nvim",
		{"williamboman/mason-lspconfig.nvim", }, 
    { "WhoIsSethDaniel/mason-tool-installer.nvim", }, -- Auto-installer for linters/formatters
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

    local on_attach = function(client, bufnr)
      local wk = require("which-key")
      wk.register({
        g = {
          name = "LSP",
          g  = { "<cmd>lua vim.lsp.buf.hover()<CR>",            "Show hover information" },
          d  = { "<cmd>lua vim.lsp.buf.definition()<CR>",       "Go to definition" },
          D  = { "<cmd>lua vim.lsp.buf.declaration()<CR>",      "Go to declaration" },
          i  = { "<cmd>lua vim.lsp.buf.implementation()<CR>",   "Go to implementation" },
          t  = { "<cmd>lua vim.lsp.buf.type_definition()<CR>",  "Go to type definition" },
          r  = { "<cmd>lua vim.lsp.buf.references()<CR>",       "Find references" },
          s  = { "<cmd>lua vim.lsp.buf.signature_help()<CR>",   "Show signature help" },
          f  = { "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", "Format code" },
          a  = { "<cmd>lua vim.lsp.buf.code_action()<CR>",      "Show code actions" },
          l  = { "<cmd>lua vim.diagnostic.open_float()<CR>",    "Show diagnostics" },
          p  = { "<cmd>lua vim.diagnostic.goto_prev()<CR>",     "Prev diagnostic" },
          n  = { "<cmd>lua vim.diagnostic.goto_next()<CR>",     "Next diagnostic" },
          tr = { "<cmd>lua vim.lsp.buf.document_symbol()<CR>",  "List document symbols" },
        },
        r = {
          name = "Refactor",
          r = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename symbol" },
        },
        ["<C-Space>"] = { "<cmd>lua vim.lsp.buf.completion()<CR>", "Trigger completion", mode = "i" },
      }, {
        prefix = "<leader>",
        buffer = bufnr,
        mode   = { "n", "v", "i" },
      })
    end

    local servers = {
			vue_ls = {
				filetypes = { "vue", "javascript", "html" },
				init_options = {
					vue = {
						hybridMode = false,
					},
				},
			},
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

    local mlsp       = require("mason-lspconfig")
    local available  = mlsp.get_available_servers()

    local avail_set  = {}
    for _, name in ipairs(available) do
      avail_set[name] = true
    end

    mlsp.setup({
      ensure_installed = to_install,
      handlers = {
        function(server_name)
          local opts = vim.tbl_deep_extend("force", {}, servers[server_name] or {})
          opts.on_attach    = opts.on_attach or on_attach
          opts.capabilities = capabilities
          require("lspconfig")[server_name].setup(opts)
        end,
      },
    })
	end,
}

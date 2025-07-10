local util = require("lspconfig.util")

local root_files = {
	"pyproject.toml",
	"setup.py",
	"setup.cfg",
	"requirements.txt",
	"Pipfile",
	"pyrightconfig.json",
	".git",
}

local function organize_imports()
	local params = {
		command = "pyright.organizeimports",
		arguments = { vim.uri_from_bufnr(0) },
	}

	local clients = util.get_lsp_clients({
		bufnr = vim.api.nvim_get_current_buf(),
		name = "pyright",
	})

	for _, client in ipairs(clients) do
		client.request("workspace/executeCommand", params, nil, 0)
	end
end

local function set_python_path(path)
	local clients = util.get_lsp_clients({
		bufnr = vim.api.nvim_get_current_buf(),
		name = "pyright",
	})

	for _, client in ipairs(clients) do
		if client.settings then
			client.settings.python = vim.tbl_deep_extend("force", client.settings.python, { pythonPath = path })
		else
			client.config.settings =
				vim.tbl_deep_extend("force", client.config.settings, { python = { pythonPath = path } })
		end
		client.notify("workspace/didChangeConfiguration", { settings = nil })
	end
end

local pyright_config = {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_dir = function(fname)
		return util.root_pattern(unpack(root_files))(fname)
	end,
	single_file_support = true,
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "off",
				typeCheckingMode = "off",
			},
		},
	},
}

return {
	config = pyright_config,
	commands = {
		PyrightOrganizeImports = {
			organize_imports,
			description = "Organize Imports",
		},
		PyrightSetPythonPath = {
			set_python_path,
			description = "Reconfigure pyright with the provided python path",
			nargs = 1,
			complete = "file",
		},
	},
	docs = {
		description = [[
https://github.com/microsoft/pyright

`pyright`, a static type checker and language server for python
]],
	},
	on_attach = function(client, bufnr)
    local wk = require("which-key")
		wk.register({
			g = {
				name = "LSP",
				g = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Show hover information" },
				d = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Go to definition" },
				D = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Go to declaration" },
				i = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Go to implementation" },
				t = { "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Go to type definition" },
				r = { "<cmd>lua vim.lsp.buf.references()<CR>", "Find references" },
				s = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Show signature help" },
				f = { "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", "Format code" },
				a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Show code actions" },
				l = { "<cmd>lua vim.diagnostic.open_float()<CR>", "Show diagnostics" },
				p = { "<cmd>lua vim.diagnostic.goto_prev()<CR>", "Prev diagnostic" },
				n = { "<cmd>lua vim.diagnostic.goto_next()<CR>", "Next diagnostic" },
				tr = { "<cmd>lua vim.lsp.buf.document_symbol()<CR>", "List document symbols" },
			},
			r = {
				name = "Refactor",
				r = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename symbol" },
			},
			["<C-Space>"] = { "<cmd>lua vim.lsp.buf.completion()<CR>", "Trigger completion", mode = "i" },
		}, {
			prefix = "<leader>",
			buffer = bufnr,
			mode = { "n", "v", "i" },
		})
	end,
}

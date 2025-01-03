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

local function setup_pyright()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

	capabilities.textDocument = capabilities.textDocument or {}
	capabilities.textDocument.publishDiagnostics = capabilities.textDocument.publishDiagnostics or {}
	capabilities.textDocument.publishDiagnostics.tagSupport = {
		valueSet = { 2 },
	}

	-- Configure pyright server with settings
	require("lspconfig").pyright.setup({
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
		-- Add the extended capabilities here
		capabilities = capabilities,
	})
end

return {
	setup = setup_pyright,
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
}

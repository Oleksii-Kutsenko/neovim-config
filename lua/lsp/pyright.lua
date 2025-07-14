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
    wk.add({
        -- LSP group and mappings (for modes n, v, i)
        {
            mode = { "n", "v", "i" },
            { "<leader>g", group = "LSP", buffer = bufnr },
            { "<leader>gg", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "Show hover information", buffer = bufnr },
            { "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>", desc = "Go to definition", buffer = bufnr },
            { "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", desc = "Go to declaration", buffer = bufnr },
            { "<leader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", desc = "Go to implementation", buffer = bufnr },
            { "<leader>gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", desc = "Go to type definition", buffer = bufnr },
            { "<leader>gr", "<cmd>lua vim.lsp.buf.references()<CR>", desc = "Find references", buffer = bufnr },
            { "<leader>gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", desc = "Show signature help", buffer = bufnr },
            { "<leader>gf", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", desc = "Format code", buffer = bufnr },
            { "<leader>ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "Show code actions", buffer = bufnr },
            { "<leader>gl", "<cmd>lua vim.diagnostic.open_float()<CR>", desc = "Show diagnostics", buffer = bufnr },
            { "<leader>gp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", desc = "Prev diagnostic", buffer = bufnr },
            { "<leader>gn", "<cmd>lua vim.diagnostic.goto_next()<CR>", desc = "Next diagnostic", buffer = bufnr },
            { "<leader>gtr", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", desc = "List document symbols", buffer = bufnr },
            -- Refactor group and mappings
            { "<leader>r", group = "Refactor", buffer = bufnr },
            { "<leader>rr", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "Rename symbol", buffer = bufnr },
        },
        -- Insert-mode only mapping for completion (with leader prefix as per your config)
        { "<leader><C-Space>", "<cmd>lua vim.lsp.buf.completion()<CR>", desc = "Trigger completion", mode = "i", buffer = bufnr },
    })
end,
}

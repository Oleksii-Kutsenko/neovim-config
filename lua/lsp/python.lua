local function get_python_path_for_project()
	-- Check if the project has a `.python-version` file
	local project_root = vim.fn.getcwd()
	local python_version_file = project_root .. "\\.python-version"

	-- If the `.python-version` file exists, use pyenv to get the python path for that version
	if vim.fn.filereadable(python_version_file) == 1 then
		local version = vim.fn.trim(vim.fn.readfile(python_version_file)[1])
		local python_path = vim.fn.trim(vim.fn.system("pyenv which python@" .. version))

		if vim.fn.executable(python_path) == 1 then
			return python_path
		end
	end

	-- Default Python executable if no .python-version file is found
	return vim.fn.trim(vim.fn.system("pyenv which python"))
end

local python_host_prog = get_python_path_for_project()

if vim.fn.has("win32") == 1 then
	-- Convert Unix-style paths to Windows-style paths
	python_host_prog = python_host_prog:gsub("/", "\\")
end

vim.g.python3_host_prog = python_host_prog

print("Python3 host program set to: " .. vim.g.python3_host_prog)

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
	{ "<leader>gf", "<cmd>lua vim.lsp.buf.format({async = true})<CR>", desc = "Format code", mode = { "n", "v" } },
	{ "<leader>ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "Show code actions" },
	{ "<leader>gl", "<cmd>lua vim.diagnostic.open_float()<CR>", desc = "Show diagnostics in floating window" },
	{ "<leader>gp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", desc = "Go to previous diagnostic" },
	{ "<leader>gn", "<cmd>lua vim.diagnostic.goto_next()<CR>", desc = "Go to next diagnostic" },
	{ "<leader>t", group = "Symbols" },
	{ "<leader>tr", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", desc = "List document symbols" },
	{ "<leader>r", group = "Refactor" },
	{ "<leader>rr", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "Rename symbol" },
	{ "<C-Space>", "<cmd>lua vim.lsp.buf.completion()<CR>", desc = "Trigger completion", mode = "i" },
})

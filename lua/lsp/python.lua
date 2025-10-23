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

vim.lsp.config("ty", {
	cmd = { "ty", "server" },
	filetypes = { "python" },
	root_markers = { "ty.toml", "pyproject.toml", ".git" },
})
vim.lsp.enable({ "ty" })

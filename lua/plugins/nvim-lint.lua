return {
	-- https://github.com/mfussenegger/nvim-lint
	"mfussenegger/nvim-lint",
	event = "BufWritePost",
	config = function()
		local lint = require("lint")
		-- Define a table of linters for each filetype (not extension).
		-- Additional linters can be found here: https://github.com/mfussenegger/nvim-lint#available-linters
		lint.linters_by_ft = {
			python = {
				"mypy",
				"pylint",
			},
		}

		local function find_config(filename)
			local config_path = vim.fn.findfile(filename, ".;")
			if config_path ~= "" then
				return config_path
			end
			return nil
		end

		local pylintrc = find_config(".pylintrc")
		if pylintrc then
			lint.linters.pylint.args = { "--rcfile=" .. pylintrc }
		end

		local pyproject = find_config("pyproject.toml")
		if pyproject then
			lint.linters.mypy.args = { "--config-file", pyproject }
		end

		-- Automatically run linters after saving.  Use "InsertLeave" for more aggressive linting.
		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			pattern = { "*.py" },
			callback = function()
				local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

				if project_name == "ai-service" then
					require("lint").try_lint("ruff")
				else
					require("lint").try_lint()
				end
			end,
		})
	end,
}

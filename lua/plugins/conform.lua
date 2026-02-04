return {
	"stevearc/conform.nvim",
	cmd = { "ConformInfo" },
	event = "VeryLazy",
	keys = {
		{
			"<leader>F",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = "n",
			desc = "Format buffer",
		},
	},

	---@module "conform"
	---@type conform.setupOpts
	opts = function()
		local util = require("conform.util")

		return {
			formatters = {
				shfmt = {
					prepend_args = { "-i", "2" },
				},
				isort = {
					command = "isort",
					args = { "-" },
				},
				black = {
					command = "black",
					args = { "-" },
				},
				djlint = {
					command = "djlint",
					args = {
						"--format-js",
						"--format-css",
						"--reformat",
						"-",
					},
				},
				stylua = {},
				rustfmt = {},
				prettierd = {
					condition = function()
						local current_dir = vim.fn.expand("%:p:h")
						local path_spec = current_dir .. ";"
						local prettier_configs = {
							".prettierrc",
							".prettierrc.json",
							".prettierrc.yaml",
							".prettierrc.yml",
							".prettierrc.toml",
							".prettierrc.js",
							"prettier.config.js",
						}
						for _, config_name in ipairs(prettier_configs) do
							if vim.fn.findfile(config_name, path_spec) ~= "" then
								return true
							end
						end
						return false
					end,
				},
				pyproject_fmt = {
					command = "pyproject-fmt",
					args = { "-" },
					cwd = util.root_file({ "pyproject.toml" }),
					exit_codes = { 0, 1 },
				},
				trim_whitespace = {},
				ruff_format = {},
				ruff_organize_imports = {},
			},

			formatters_by_ft = {
				htmldjango = { "djlint" },
				lua = { "stylua" },
				python = { "ruff_organize_imports", "ruff_format" },
				rust = { "rustfmt", lsp_format = "fallback" },
				html = { "prettierd" },
				javascript = { "prettierd" },
				javascriptreact = { "prettierd" },
				markdown = { "prettierd" },
				typescript = { "prettierd" },
				typescriptreact = { "prettierd" },
				vue = { "prettierd" },
				toml = { "pyproject_fmt" },
				sql = { "sql_formatter" },
                json = { "prettier" },
                jsonc = { "prettier" },
				["*"] = { "trim_whitespace" },
			},

			format_on_save = function(bufnr)
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				return { timeout_ms = 2000, lsp_format = "fallback" }
			end,

			log_level = vim.log.levels.ERROR,
			notify_on_error = true,
			notify_no_formatters = true,
		}
	end,

	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}

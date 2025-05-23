return {
	"stevearc/conform.nvim",
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = "n",
			desc = "Format buffer",
		},
	},
	---@module "conform"
	---@type conform.setupOpts
	opts = {
		formatters = {
			shfmt = {
				prepend_args = { "-i", "2" },
			},
			isort = {
				command = "isort",
				args = {
					"-",
				},
			},
			black = {
				command = "black",
				args = {
					"-",
				},
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
			},
			trim_whitespace = {},
			ruff_format = {},
			ruff_organize_imports = {},
		},

		formatters_by_ft = {
			htmldjango = { "djlint" },
			lua = { "stylua" },
			python = function(bufnr)
				local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
				local project_formatters = {
					["dilema"] = { "isort", "black" },
					["ai-service"] = { "ruff_format", "ruff_organize_imports" },
				}
				return project_formatters[project_name] or { "isort", "black" }
			end,
			rust = { "rustfmt", lsp_format = "fallback" },
			html = { "prettierd" },
			javascript = { "prettierd" },
			javascriptreact = { "prettierd" },
			markdown = { "prettierd" },
			typescript = { "prettierd" },
			typescriptreact = { "prettierd" },
			vue = { "prettierd" },
			toml = { "pyproject_fmt" },
			["*"] = { "trim_whitespace" },
		},

		format_on_save = function(bufnr)
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end
			return { timeout_ms = 3000, lsp_format = "fallback" }
		end,

		log_level = vim.log.levels.ERROR,
		notify_on_error = true,
		notify_no_formatters = true,
	},
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}

return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true })
			end,
			mode = "n",
			desc = "Format buffer",
		},
	},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
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
				-- Apply trim_whitespace for all files
				["*"] = { "trim_whitespace" },
			},
			format_on_save = function(bufnr)
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				return { timeout_ms = 500, lsp_format = "fallback" }
			end,
			format_after_save = {
				lsp_format = "fallback",
			},
			log_level = vim.log.levels.ERROR,
			notify_on_error = true,
			notify_no_formatters = true,
			formatters = {
				prettierd = {
					stop_after_first = true,
					condition = function()
						local file_path = vim.fn.expand("%:p:h")
						local found_prettierrc = vim.fn.findfile(".prettierrc", file_path .. ";")

						if found_prettierrc == "" then
							found_prettierrc = vim.fn.findfile(".prettierrc", file_path .. "/..;")
						end

						return found_prettierrc ~= ""
					end,
				},
			},
		})
	end,
	---@module "conform"
	---@type conform.setupOpts
	opts = {
		default_format_opts = {
			lsp_format = "fallback",
		},
		formatters = {
			shfmt = {
				prepend_args = { "-i", "2" },
			},
			isort = {
				command = "isort",
				args = {
					"--le lf",
					"-",
				},
			},
			black = {
				command = "black",
				args = {
					"-",
				},
			},
		},
	},
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}

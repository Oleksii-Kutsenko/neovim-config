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
			mode = "",
			desc = "Format buffer",
		},
	},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
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
				return { timeout_ms = 1000, lsp_format = "fallback" }
			end,
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
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
		},
		default_format_opts = {
			lsp_format = "fallback",
		},
		format_on_save = { timeout_ms = 1000 },
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

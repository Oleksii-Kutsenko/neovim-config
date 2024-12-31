return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-nvim-lsp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
	},
	config = function()
		local has_words_before = function()
			unpack = unpack or table.unpack
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
		end

		local cmp = require("cmp")
		local luasnip = require("luasnip")

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			completion = {
				autocomplete = { cmp.TriggerEvent.TextChanged, cmp.TriggerEvent.InsertEnter },
				keyword_length = 2,
			},
			mapping = cmp.mapping.preset.insert({
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item() -- Select next item in completion
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump() -- Expand snippet or jump
					elseif has_words_before() then
						cmp.complete() -- Trigger completion
					else
						fallback() -- Fall back to default behavior
					end
				end, { "i", "s" }),

				["<s-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item() -- Select previous item in completion
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1) -- Jump back in snippet
					else
						fallback() -- Fall back to default behavior
					end
				end, { "i", "s" }),

				["<c-e>"] = cmp.mapping.abort(), -- Abort completion
				["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirm selected completion item
			}),
			sources = {
				{ name = "nvim_lsp" }, -- LSP completion source
				{ name = "luasnip" }, -- LuaSnip completion source
				{ name = "buffer" },
				{ name = "path" },
			},
		})
	end,
}

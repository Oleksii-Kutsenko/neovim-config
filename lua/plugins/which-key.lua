return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
		{
			"<Space>w",
			":w<CR>",
			desc = "Save file",
		},
		{
			"J",
			":m .+1<CR>==",
			mode = "n",
			desc = "Move line down",
		},
		{
			"K",
			":m .-2<CR>==",
			mode = "n",
			desc = "Move line up",
		},
		{
			"J",
			":m .+1<CR>==gi",
			mode = "i",
			desc = "Move line down (insert mode)",
		},
		{
			"K",
			":m .-2<CR>==gi",
			mode = "i",
			desc = "Move line up (insert mode)",
		},
		{
			"<space>ca",
			function()
				vim.lsp.buf.code_action()
			end,
			desc = "LSP Code Action",
		},
	},
}

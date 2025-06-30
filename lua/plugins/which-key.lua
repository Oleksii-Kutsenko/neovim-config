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
		-- General keymaps
		{
			"<Space>ww",
			":w<CR>",
			mode = "n",
			desc = "Save file",
		},
		{
			"<Space>qq",
			":q!<CR>",
			mode = "n",
			desc = "Quit without saving",
		},
		{
			"<Space>wq",
			":wq<CR>",
			mode = "n",
			desc = "Save and quit",
		},
		{
			"<leader>yp",
			function()
				local filepath = vim.fn.expand("%:p")
				vim.fn.setreg("+", filepath)
				print("Yanked file path: " .. filepath)
			end,
			desc = "Yank file path",
		},
		{
			"zf#j",
			desc = "Create fold from cursor down # lines",
		},
		{
			"zf/string",
			desc = "Create fold from cursor to string",
		},
		{
			"zj",
			desc = "Move to the next fold",
		},
		{
			"zk",
			desc = "Move to the previous fold",
		},
		{
			"zo",
			desc = "Open fold at cursor",
		},
		{
			"zO",
			desc = "Open all folds at cursor",
		},
		{
			"zm",
			desc = "Increase foldlevel by one",
		},
		{
			"zM",
			desc = "Close all open folds",
		},
		{
			"zr",
			desc = "Decrease foldlevel by one",
		},
		{
			"zR",
			desc = "Decrease foldlevel to zero (open all folds)",
		},
		{
			"zd",
			desc = "Delete fold at cursor",
		},
		{
			"zE",
			desc = "Delete all folds",
		},
		{
			"[z",
			desc = "Move to start of open fold",
		},
		{
			"]z",
			desc = "Move to end of open fold",
		},

		-- Splits
		{
			"<leader>sv",
			"<C-w>v",
			mode = "n",
			desc = "Split window vertically",
		},
		{
			"<leader>sb",
			"<C-w>s",
			mode = "n",
			desc = "Split window horizontally",
		},
		{
			"<leader>se",
			"<C-w>=",
			mode = "n",
			desc = "Make split windows equal width",
		},
		{
			"<leader>sx",
			":close<CR>",
			mode = "n",
			desc = "Close split window",
		},
		{
			"<leader>sj",
			"<C-w>-",
			mode = "n",
			desc = "Make split window height shorter",
		},
		{
			"<leader>sk",
			"<C-w>+",
			mode = "n",
			desc = "Make split windows height taller",
		},
		{
			"<leader>sl",
			"<C-w>>5",
			mode = "n",
			desc = "Make split windows width bigger",
		},
		{
			"<leader>sh",
			"<C-w><5",
			mode = "n",
			desc = "Make split windows width smaller",
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

		-- Tab management keymaps
		{ "<leader>t", group = "Tab page" },
		{
			"<leader>to",
			":tabnew<CR>",
			mode = "n",
			desc = "Open a new tab",
		},
		{
			"<leader>tx",
			":tabclose<CR>",
			mode = "n",
			desc = "Close the current tab",
		},
		{
			"<leader>tn",
			":tabn<CR>",
			mode = "n",
			desc = "Go to the next tab",
		},
		{
			"<leader>tp",
			":tabp<CR>",
			mode = "n",
			desc = "Go to the previous tab",
		},
		{
			"<leader>tt",
			":tab split<CR>",
			mode = "n",
			desc = "Open current buffer in a new tab page",
		},
		{
			"<leader>p",
			'"_dP',
			mode = "v",
			desc = "Paste yank register",
		},
	},
}

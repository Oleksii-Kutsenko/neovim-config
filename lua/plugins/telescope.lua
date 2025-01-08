return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = { "nvim-lua/plenary.nvim", "BurntSushi/ripgrep" },
	config = function()
		local wk = require("which-key")

		-- Register telescope mappings with the new spec
		wk.add({
			{ "<leader>f", group = "Telescope" },
			{
				"<leader>ff",
				function()
					require("telescope.builtin").find_files()
				end,
				desc = "Find files in project",
			},
			{
				"<leader>fg",
				function()
					require("telescope.builtin").live_grep()
				end,
				desc = "Grep file contents in project",
			},
			{
				"<leader>fb",
				function()
					require("telescope.builtin").buffers()
				end,
				desc = "Find open buffers",
			},
			{
				"<leader>fh",
				function()
					require("telescope.builtin").help_tags()
				end,
				desc = "Find help tags",
			},
			{
				"<leader>fs",
				function()
					require("telescope.builtin").current_buffer_fuzzy_find()
				end,
				desc = "Fuzzy find in current buffer",
			},
			{
				"<leader>fo",
				function()
					require("telescope.builtin").lsp_document_symbols()
				end,
				desc = "Find LSP document symbols",
			},
			{
				"<leader>fi",
				function()
					require("telescope.builtin").lsp_incoming_calls()
				end,
				desc = "Find LSP incoming calls",
			},
			{
				"<leader>fm",
				function()
					require("telescope.builtin").treesitter({ symbols = { "function", "method" } })
				end,
				desc = "Find methods in current class",
			},
			{
				"<leader>ft",
				function()
					local success, node = pcall(function()
						return require("nvim-tree.lib").get_node_at_cursor()
					end)
					if not success or not node then
						return
					end
					require("telescope.builtin").live_grep({ search_dirs = { node.absolute_path } })
				end,
				desc = "Grep file contents in current NvimTree node",
			},
      {
        "<leader>zr",
        
      }
		})
	end,
}

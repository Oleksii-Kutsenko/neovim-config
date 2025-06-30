return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	opts = { extensions_list = { "fzf" } },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"BurntSushi/ripgrep",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5 && cmake --build build --config Release",
		},
	},
	config = function()
		local telescope = require("telescope")
		telescope.setup({
			defaults = {
				-------------------------------------------------
				--  (A) PERFORMANCE TWEAKS
				-------------------------------------------------
				sorting_strategy = "ascending",
				preview = {
					filesize_limit = 2,
					timeout = 200,
				},
				file_ignore_patterns = {
					"node_modules",
				},
				-------------------------------------------------
				--  (B) UI PREFERENCES
				-------------------------------------------------
				layout_strategy = "horizontal",
				layout_config = {
					anchor = "N",
					height = 0.6,
					prompt_position = "top",
				},
				pickers = {
					live_grep = {
						debounce = 200,
					},
				},
			},
			-------------------------------------------------
			--  (C) EXTENSIONS
			-------------------------------------------------
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		})

		local function live_grep_threads(threads)
			threads = threads or "4"
			require("telescope.builtin").live_grep({
				additional_args = function()
					return { "--threads", threads }
				end,
			})
		end

		telescope.load_extension("fzf")
		local wk = require("which-key")

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
				live_grep_threads,
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
		})
	end,
}

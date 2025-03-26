return {
	"huggingface/llm.nvim",
	opts = {
		-- cf Setup
	},
	config = function()
		local llm = require("llm")

		llm.setup({
			model = "codellama:7b",
			url = "http://10.199.195.66:11434/", -- llm-ls uses "/api/generate"
			-- cf https://github.com/ollama/ollama/blob/main/docs/api.md#parameters
			request_body = {
				options = {
					temperature = 0.2,
					top_p = 0.95,
				},
			},
		})
	end,
}

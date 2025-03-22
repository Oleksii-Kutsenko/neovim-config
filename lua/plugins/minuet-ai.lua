return {
	"milanglacier/minuet-ai.nvim",
	config = function()
		require("minuet").setup({
			provider = "openai_fim_compatible",
			context_window = 512,
			request_timeout = 5,
			notify = "debug",
			provider_options = {
				openai_fim_compatible = {
					model = "qwen2.5-coder:latest",
					end_point = "http://localhost:11434/v1/completions",
					api_key = "OLLAMA_API_KEY",
					name = "Ollama",
					stream = false,
					optional = {
						max_tokens = 56,
						top_p = 0.9,
					},
				},
			},
		})
	end,
}

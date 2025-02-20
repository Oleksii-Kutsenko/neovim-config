return {
	"williamboman/mason.nvim",
	config = function()
		require("mason").setup({
			providers = {
				"mason.providers.client",
				"mason.providers.registry-api",
			},
		})
	end,
	opts = {
		ensure_installed = {
			"pyright",
			"pylint",
			"mypy",
		},
	},
}

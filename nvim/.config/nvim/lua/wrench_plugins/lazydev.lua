return {
	{
		url = "https://github.com/folke/lazydev.nvim",
		ft = { "lua" },
		config = function()
			require("lazydev").setup({
				library = {
					{ path = "${3rd}/busted/library", words = { "describe" } },
					{ path = "${3rd}/luassert/library", words = { "assert" } },
				},
			})
		end,
	},
}

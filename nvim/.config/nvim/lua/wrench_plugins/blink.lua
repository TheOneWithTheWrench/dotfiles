return {
	url = "https://github.com/saghen/blink.cmp",
	-- branch = "main",
	tag = "v1.8.0",
	dependencies = {
		{ url = "https://github.com/rafamadriz/friendly-snippets" },
	},
	config = function()
		local opts = {
			keymap = {
				["<CR>"] = { "select_and_accept", "fallback" },
			},
			completion = {
				menu = {
					winblend = 10,
				},
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 0,
                }
			},
		}

		local blink_cmp = require("blink.cmp")

		blink_cmp.setup(opts)

		vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
	end,
}

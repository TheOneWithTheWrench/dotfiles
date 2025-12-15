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
            signature = {
                enabled = true,
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

		require("blink.cmp").setup(opts)

		local function set_transparency()
			vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
		end

		set_transparency()

        -- We have to make an auto command here to combat a race whether our ColorScheme or blink loads first
		vim.api.nvim_create_autocmd("ColorScheme", { callback = set_transparency })
	end,
}

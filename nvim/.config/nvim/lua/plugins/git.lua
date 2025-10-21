return {
	{
		"lewis6991/gitsigns.nvim",
		keys = {
			{ "<leader>hd", "<cmd>Gitsigns diffthis<cr>",  desc = "Show difference"  },
			{ "<leader>hb", "<cmd>Gitsigns blame<cr>",  desc = "Git Blame"  },
		},
		opts = {
			current_line_blame = false, -- This is the grey text after a line... Kinda useless
		},
	},
}

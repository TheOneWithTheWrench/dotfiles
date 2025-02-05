return {
	{
		"lewis6991/gitsigns.nvim",
        ft = {"go", "lua", "yaml", "yml", "json", "proto"},
		keys = {
			{ "<leader>hd", "<cmd>Gitsigns diffthis<cr>", { desc = "Show difference" } },
		},
		opts = {
			current_line_blame = true,
		},
	},
}

return {
	{
		"lewis6991/gitsigns.nvim",
		keys = {
			{ "<leader>hd", "<cmd>Gitsigns diffthis<cr>", { desc = "Show difference" } },
		},
		opts = {
			current_line_blame = true,
  			signs_visible = false,
		},
	},
}

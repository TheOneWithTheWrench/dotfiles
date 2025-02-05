return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = { enabled = true },
		notifier = { enabled = true, style = "compact" },
		quickfile = { enabled = true },
		statuscolumn = { enabled = true },
		lazygit = { enabled = true, win = { height = 0.8, width = 0.8 } },
		zen = { enabled = true },
		terminal = {
			win = {
				style = "float",
				border = "rounded",
				height = 0.65,
				width = 0.7,
				title = "Morten's terminal",
			},
		},
	},
    --stylua: ignore
    keys = {
        { "<leader>gg", function() Snacks.lazygit() end,  desc = "Lazygit" },
        { "<c-_>",      function() Snacks.terminal() end, desc = "Toggle Terminal", mode = { "n", "t" }, },   -- For MacOS
        { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal", mode = { "n", "t" }, },   -- For Windows
        { "<leader>z",  function() Snacks.zen() end,      desc = "Zen Mode" },

    },
	--stylua: end
}

return {
	url = "https://github.com/folke/snacks.nvim",
    keys = {
        -- LazyGit
        { lhs = "<leader>gg", rhs = function() require("snacks").lazygit() end, desc = "Lazygit" },

        -- Terminal
        { lhs = "<c-_>", rhs = function() require("snacks").terminal() end, desc = "Toggle Terminal", mode = { "n", "t" } },-- For Mac
        { lhs = "<c-/>", rhs = function() require("snacks").terminal() end, desc = "Toggle Terminal", mode = { "n", "t" } },-- For Windows

        -- Zen Mode
        { lhs = "<leader>z", rhs = function() require("snacks").zen() end, desc = "Zen Mode" },

        -- Pickers
        { lhs = "<leader><Space>",  rhs = function() require("snacks").picker.files({layout = { preview = { enabled = false}}}) end,    desc = "Snacks File Picker" },
        { lhs = "<leader>fg",       rhs = function() require("snacks").picker.grep({}) end,                                             desc = "Snacks Grep Picker" },
        { lhs = "<leader>fb",       rhs = function() require("snacks").picker.grep_buffers({}) end,                                     desc = "Snacks Grep Buffers Picker" },
    },
	config = function()
		local opts = {
			bigfile = { enabled = true },
			-- notifier = { enabled = true, style = "compact" },
            picker = { enabled = true },
			quickfile = { enabled = true },
			statuscolumn = { enabled = false },
			lazygit = { enabled = true, win = { height = 0.8, width = 0.8 } },
			zen = { enabled = true, toggles = { dim = false, git_signs = true, mini_diff_signs = true } }, -- diagnostics = false, inlay_hints = false, }},
			terminal = {
				win = {
					style = "float",
					border = "rounded",
					height = 0.65,
					width = 0.7,
					title = "Morten's terminal",
				},
			},
		}

        require("snacks").setup(opts)
	end,
}

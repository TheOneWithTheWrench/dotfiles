return {
	url = "https://github.com/folke/snacks.nvim",
	config = function()
		local opts = {
			bigfile = { enabled = true },
			-- notifier = { enabled = true, style = "compact" },
            picker = { enabled = true },
			quickfile = { enabled = true },
			statuscolumn = { enabled = true },
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

        local snacks = require("snacks")

        snacks.setup(opts)

        vim.keymap.set("n", "<leader>gg", function() snacks.lazygit() end, { desc = "Lazygit" })
        vim.keymap.set({ "n", "t" }, "<c-_>", function() snacks.terminal() end, { desc = "Toggle Terminal" }) -- For Mac
        vim.keymap.set({ "n", "t" }, "<c-/>", function() snacks.terminal() end, { desc = "Toggle Terminal" }) -- For Windows
        vim.keymap.set("n", "<leader>z", function() snacks.zen() end, { desc = "Zen Mode" })

        -- Pickers
        vim.keymap.set("n", "<leader><Space>", function() snacks.picker.files({layout = { preview = { enabled = false}}}) end, { desc = "Snacks File Picker" })
        vim.keymap.set("n", "<leader>fg", function() snacks.picker.grep({}) end, { desc = "Snacks Grep Picker" })
        vim.keymap.set("n", "<leader>fb", function() snacks.picker.grep_buffers({}) end, { desc = "Snacks Grep Buffers Picker" })
	end,
}

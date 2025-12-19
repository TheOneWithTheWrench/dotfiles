return {
	{
		url = "https://github.com/nvim-neotest/neotest",
		ft = { "go", "gomod", "lua" },
		dependencies = {
			-- Long story short: Trees(h)itter has deprecated the master branch and is migrating to main branch
			-- In that regard, they decided it was a good idea to make huge breaking changes.
			-- fredrikaverpil's version 2 of neotest-golang tries to support this but fails miserably
			-- So Locking to this version for now as it seems stable
			{ url = "https://github.com/nvim-neotest/nvim-nio" },
			{ url = "https://github.com/antoinemadec/FixCursorHold.nvim" },
			{ url = "https://github.com/nvim-lua/plenary.nvim" },
			{ url = "https://github.com/nvim-treesitter/nvim-treesitter" },

            -- Languages
			{ url = "https://github.com/fredrikaverpil/neotest-golang" },
            { url = "https://github.com/nvim-neotest/neotest-plenary"},
		},
		config = function()
			local neotestOpts = {
				status = { virtual_text = true },
				output = { open_on_run = true },
				quickfix = {
					enabled = false,
				},
				adapters = {
					require("neotest-golang")({
						runner = "gotestsum",
					}),
					["neotest-golang"] = {
						go_test_args = { "-v", "-race", "-count=1", "-tags=integration" },
					},
                    require("neotest-plenary").setup({
                        min_init = "./tests/minimal_init.lua",
                    }),
				},
			}

			require("neotest").setup(neotestOpts)

            --Keybinds
            vim.keymap.set("n", "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, { desc = "Run File" })
            vim.keymap.set("n", "<leader>tT", function() require("neotest").run.run(vim.loop.cwd()) end, { desc = "Run All Test Files" })
            vim.keymap.set("n", "<leader>tr", function() require("neotest").run.run() end, { desc = "Run Nearest" })
            vim.keymap.set("n", "<leader>ts", function() require("neotest").summary.toggle() end, { desc = "Toggle Summary" })
            vim.keymap.set("n", "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, { desc = "Show Output" })
            vim.keymap.set("n", "<leader>tO", function() require("neotest").output_panel.toggle() end, { desc = "Toggle Output Panel" })
            vim.keymap.set("n", "<leader>tS", function() require("neotest").run.stop() end, { desc = "Stop" })
		end,
	},
}

return {
	url = "https://github.com/folke/snacks.nvim",
    ft = { "markdown" },
    keys = {
        -- LazyGit
        { lhs = "<leader>gg", rhs = function() require("snacks").lazygit() end, desc = "Lazygit" },

        -- Terminal
        { lhs = "<c-_>", rhs = function() require("snacks").terminal() end, desc = "Toggle Terminal", mode = { "n", "t" } },-- For Mac
        { lhs = "<c-/>", rhs = function() require("snacks").terminal() end, desc = "Toggle Terminal", mode = { "n", "t" } },-- For Windows

        -- Zen Mode
        { lhs = "<leader>z", rhs = function() require("snacks").zen() end, desc = "Zen Mode" },

        -- Pickers
        { lhs = "<leader><Space>",  rhs = function()
            pcall(function()
                require("mini.files").close()
            end)

            vim.schedule(function()
                require("snacks").picker.files({
                    show_delay = 0,
                    layout = { preview = { enabled = false } },
                })
            end)
        end,    desc = "Snacks File Picker" },
        { lhs = "<leader>fg",       rhs = function() require("snacks").picker.grep({}) end,                                             desc = "Snacks Grep Picker" },
        { lhs = "<leader>fb",       rhs = function() require("snacks").picker.grep_buffers({}) end,                                     desc = "Snacks Grep Buffers Picker" },
    },
	config = function()
		local opts = {
			bigfile =       { enabled = true },
            image =         {
                enabled = true,
                doc = {
                    enabled = true,
                    inline = true,
                    max_width = 120,
                    max_height = 40,
                    conceal = function(_, image_type)
                        return image_type == "chart"
                    end,
                },
                convert = {
                    notify = true,
                    mermaid = function()
                        local theme = vim.o.background == "light" and "neutral" or "dark"
                        return { "-i", "{src}", "-o", "{file}", "-b", "transparent", "-t", theme, "--scale", "{scale}", "-q" }
                    end,
                },
            },
            picker =        { enabled = true, ui_select = false },
			quickfile =     { enabled = true },
			statuscolumn =  { enabled = false },
			lazygit =       { enabled = true, win = { height = 0.8, width = 0.8 } },
			zen =           { enabled = true, toggles = { dim = false, git_signs = true, mini_diff_signs = true } }, -- diagnostics = false, inlay_hints = false, }},
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

        vim.schedule(function()
            local image = require("snacks.image")
            image.setup()

            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == "markdown" then
                    image.doc.attach(buf)
                end
            end
        end)
	end,
}

return {
    url = "https://github.com/lewis6991/gitsigns.nvim",
    ft = require("filetypes"),
    keys = {
        { lhs = "<leader>hd", rhs = function() vim.cmd("Gitsigns diffthis") end,   desc = "Show difference" },
        { lhs = "<leader>hb", rhs = function() vim.cmd("Gitsigns blame") end,      desc = "Git Blame" },
    },
    config = function()
        local gitsigns = require("gitsigns")

        gitsigns.setup({
            current_line_blame = false, -- This is the grey text after a line... Kinda useless
            signcolumn = false, -- Toggle with `:Gitsigns toggle_signs`
        })
    end
}

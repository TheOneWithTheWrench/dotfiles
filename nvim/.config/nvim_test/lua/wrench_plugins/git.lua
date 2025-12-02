return {
    url = "https://github.com/lewis6991/gitsigns.nvim",
    ft = { "go", "lua", "javascript" },
    config = function()
        local gitsigns = require("gitsigns")

        gitsigns.setup({
            current_line_blame = false, -- This is the grey text after a line... Kinda useless
            signcolumn = false, -- Toggle with `:Gitsigns toggle_signs`
        })

        vim.keymap.set("n", "<leader>hd", "<cmd>Gitsigns diffthis<cr>",   { desc = "Show difference" })
        vim.keymap.set("n", "<leader>hb", "<cmd>Gitsigns blame<cr>",      { desc = "Git Blame" })
    end
}

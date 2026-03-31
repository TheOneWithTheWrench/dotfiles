return {
    url = "https://github.com/ellisonleao/gruvbox.nvim",
    config = function()
        require("gruvbox").setup({
            overrides = {
                FlashMatch = { bg = "#eba834", fg = "#282828" },
                FlashLabel = { bg = "#bf4239", fg = "#282828" },
            },
            transparent_mode = true,
        })
        vim.cmd.colorscheme("gruvbox")

        -- Make statusline transparent
        -- Active status line
        vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
        -- Inactive status line
        vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })
        -- prevent overrides by theme
        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "*",
            callback = function()
                vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
                vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })
            end,
        })
    end,
}

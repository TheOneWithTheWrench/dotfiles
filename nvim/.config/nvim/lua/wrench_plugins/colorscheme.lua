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
    end,
}

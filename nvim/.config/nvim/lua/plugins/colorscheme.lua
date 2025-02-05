return {
    {
        "ellisonleao/gruvbox.nvim",
        enabled = true,
        priority = 1000,
        init = function()
            vim.cmd.colorscheme("gruvbox")
        end,
        config = function()
            require("gruvbox").setup({
                overrides = {
                    FlashMatch = { bg = "#eba834", fg = "#282828" },
                    FlashLabel = { bg = "#bf4239", fg = "#282828" },
                },
                transparent_mode = true,
            })
        end,
    },
    {
        "folke/tokyonight.nvim",
        enabled = false,
        init = function()
            vim.cmd.colorscheme("tokyonight")
        end,
        priority = 1000,
        opts = {
            style = "night",
            transparent = true,
            on_highlights = function(hl, _)
                hl.FlashMatch = { bg = "#eba834", fg = "#282828" }
                hl.FlashLabel = { bg = "#bf4239", fg = "#282828" }
            end,
        },
        config = function(_, opts)
            require("tokyonight").setup(opts)
        end,
    },
    {
        "catppuccin/nvim",
        enabled = false,
        init = function()
            vim.cmd.colorscheme("catppucin")
        end,
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                transparent_background = true,
                custom_highlights = function(colors)
                    return {
                        FlashMatch = { bg = "#eba834", fg = "#282828" },
                        FlashLabel = { bg = "#bf4239", fg = "#282828" },
                    }
                end,
            })
        end,
    },
}

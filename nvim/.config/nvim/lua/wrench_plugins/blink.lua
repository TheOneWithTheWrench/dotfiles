return {
    url = "https://github.com/saghen/blink.cmp",
    tag = "v1.8.0",
    event = "InsertEnter",
    dependencies = {
        { url = "https://github.com/rafamadriz/friendly-snippets" },
    },
    config = function()
        local opts = {
            keymap = {
                preset = "default",
                ["<CR>"] = { "select_and_accept", "fallback" },
                ["<Tab>"] = {},
                ["<S-Tab>"] = {},
            },
            signature = {
                enabled = true,
            },
            completion = {
                menu = {
                    winblend = 10,
                    draw = {
                        columns = {
                            { "label",      "label_description", gap = 1 },
                            { "kind_icon",  "kind",              gap = 1 },
                            { "source_name" },
                        },
                        components = {
                            source_name = {
                                width = { max = 30 },
                                -- This function wraps the name in brackets, e.g., "LSP" -> "[LSP]"
                                text = function(ctx) return "[" .. ctx.source_name .. "]" end,
                                highlight = "BlinkCmpSource", -- You can use any highlight group here
                            },
                        },
                    },
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 0,
                }
            },
        }

        require("blink.cmp").setup(opts)

        local function set_transparency()
            vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
        end

        set_transparency()

        -- We have to make an auto command here to combat a race whether our ColorScheme or blink loads first
        vim.api.nvim_create_autocmd("ColorScheme", { callback = set_transparency })
    end,
}

return {
    "olimorris/codecompanion.nvim",
    cmd = {
        "CodeCompanion",
        "CodeCompanionActions",
        "CodeCompanionChat",
        "CodeCompanionCmd",
    },
    keys = {
        { "<leader>nc", "<cmd>CodeCompanionChat<cr>",    desc = "CodeCompanion chat" },
        { "<leader>nd", "<cmd>CodeCompanionCmd<cr>",     desc = "CodeCompanion command" },
        { "<leader>na", "<cmd>CodeCompanionActions<cr>", desc = "CodeCompanion actions" },
        { "<leader>ni", "<cmd>CodeCompanion<cr>", mode = {"n", "v"}, desc = "CodeCompanion invoke" }, -- Allow invoking in visual mode to process selections
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        {
            "MeanderingProgrammer/render-markdown.nvim",
            ft = { "codecompanion" },
        },
    },
    opts = {
        strategies = {
            chat = {
                adapter = "gemini_flash",
            },
            inline = {
                adapter = "gemini_flash",
            },
        },
        display = {
            diff = {
                provider = "mini_diff",
            },
            chat = {
                window = {
                    position = "right",
                },
            },
        },
    },
    config = function(_, opts)
        require("codecompanion").setup(vim.tbl_deep_extend("force", opts, {
            adapters = {
                gemini_flash = function()
                    return require("codecompanion.adapters").extend("gemini", {
                        display_name = "Gemini 2.5 Flash",
                        schema = {
                            model = {
                                default = "gemini-2.5-flash",
                            },
                        },
                        env = {
                            api_key = "GEMINI_API_KEY",
                        },
                    })
                end,
                gemini_pro = function()
                    return require("codecompanion.adapters").extend("gemini", {
                        display_name = "Gemini 2.5 Pro",
                        schema = {
                            model = {
                                default = "gemini-2.5-pro",
                            },
                        },
                        env = {
                            api_key = "GEMINI_API_KEY",
                        },
                    })
                end,
            },
        }))
    end,
}

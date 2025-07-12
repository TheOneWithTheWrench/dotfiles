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
        { "<leader>ni", "<cmd>CodeCompanion<cr>",        mode = { "n", "v" },           desc = "CodeCompanion invoke" }, -- Allow invoking in visual mode to process selections
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        {
            "Davidyz/VectorCode",
            build = "uv tool upgrade vectorcode", -- This helps keeping the CLI up-to-date
            -- build = "pipx upgrade vectorcode", -- If you used pipx to install the CLI
            dependencies = { "nvim-lua/plenary.nvim" },
        },
        {
            "MeanderingProgrammer/render-markdown.nvim",
            ft = { "codecompanion", "markdown" },
        },
    },
    opts = {
        -- strategies = {
        --     chat = {
        --         adapter = "gemini_flash",
        --     },
        --     inline = {
        --         adapter = "gemini_flash",
        --     },
        -- },
        strategies = {
            chat = {
                adapter = "copilot",
            },
            inline = {
                adapter = "copilot",
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
        extensions = {
            vectorcode = {
                opts = {
                    tool_group = {
                        -- this will register a tool group called `@vectorcode_toolbox` that contains all 3 tools
                        enabled = true,
                        -- a list of extra tools that you want to include in `@vectorcode_toolbox`.
                        -- if you use @vectorcode_vectorise, it'll be very handy to include
                        -- `file_search` here.
                        extras = {},
                        collapse = false, -- whether the individual tools should be shown in the chat
                    },
                    tool_opts = {
                        ls = {},
                        vectorise = {},
                        query = {
                            max_num = { chunk = -1, document = -1 },
                            default_num = { chunk = 50, document = 10 },
                            include_stderr = false,
                            use_lsp = false,
                            no_duplicate = true,
                            chunk_mode = false,
                            summarise = {
                                enabled = false,
                                adapter = nil,
                                query_augmented = true,
                            },
                        },
                        files_ls = {},
                        files_rm = {},
                    },
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
                tavily = function()
                    return require("codecompanion.adapters").extend("tavily", {
                        env = {
                            api_key = "TAVILY_API_KEY",
                        },
                    })
                end,
            },
        }))
    end,
}

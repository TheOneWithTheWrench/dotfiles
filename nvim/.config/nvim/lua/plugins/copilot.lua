return {
    {
        "github/copilot.vim",
        keys = {
            {
                "<leader>he",
                function()
                    vim.cmd("Copilot enable")
                    vim.cmd("Copilot status")
                end,
                desc = "Enable copilot",
            },
            {
                "<leader>ho",
                function()
                    vim.cmd("Copilot disable")
                    vim.cmd("Copilot status")
                end,
                desc = "Disable copilot",
            },
        },
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        cmd = "CopilotChat",
        dependencies = {
            { "github/copilot.vim" },              -- or zbirenbaum/copilot.lua
            { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
        },
        build = "make tiktoken",                   -- Only on MacOS or Linux
        branch = "release-please--branches--main",
        opts = {
            mappings = {
                reset = {
                    normal = "<C-x>",
                    insert = "<C-x>",
                },
                complete = {
                    insert = "<S-Tab>",
                }
            },
            -- See Configuration section for options
        },
        -- See Commands section for default commands if you want to lazy load on them
    },
}

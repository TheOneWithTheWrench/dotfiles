return {
    {
        url = "https://github.com/ThePrimeagen/99",
        dependencies = {
            { url = "https://github.com/saghen/blink.compat" },
        },
        keys = {
            {
                mode = { "v" },
                lhs = "<leader>9v",
                rhs = function() require("99").visual() end,
                desc = "99 Visual",
            },
            {
                mode = { "n" },
                lhs = "<leader>9o",
                rhs = function() require("99").open() end,
                desc = "99 Open previous results",
            },
            {
                mode = { "n" },
                lhs = "<leader>9x",
                rhs = function() require("99").stop_all_requests() end,
                desc = "99 Stop All Requests",
            },
            {
                mode = { "n" },
                lhs = "<leader>9s",
                rhs = function() require("99").search() end,
                desc = "99 Search",
            },
            {
                mode = { "n" },
                lhs = "<leader>9b",
                rhs = function() require("99").vibe() end,
                desc = "99 Vibe",
            }
        },
        config = function()
            local _99 = require("99")
            _99.setup({
                provider = _99.Providers.CursorAgentProvider,
                model = "composer-2.5-fast",
                completion = {
                    custom_rules = {
                        "scratch/custom_rules/",
                    },
                    source = "blink",
                },
                md_files = {
                    "AGENT.md",
                    "CLAUDE.md",
                },
            })
        end,
    },
}

return {
    url = "https://github.com/emrearmagan/atlas.nvim",
    cmd = { "Atlas" },
    keys = {
        {
            lhs = "<leader>gA",
            rhs = "<cmd>Atlas pulls github<cr>",
            desc = "Open Atlas GitHub pull requests",
        },
    },
    dependencies = {
        { url = "https://github.com/nvim-tree/nvim-web-devicons" },
    },
    config = function()
        -- Keep token-based REST providers disabled until Atlas restricts cross-host redirects.
        require("atlas").setup({
            providers = {
                github = {},
            },
            keymaps = {
                ui = {
                    submit = "<C-g>",
                },
            },
            pulls = {
                diff = {
                    lsp = {
                        enabled = true,
                    },
                },
                github = {
                    views = {
                        {
                            name = "Review requested",
                            key = "1",
                            layout = "grouped",
                            search = "is:pr review-requested:@me state:open archived:false sort:updated-desc -author:lunar-renovate -author:lunar-renovatebot[bot] -is:draft",
                        },
                        {
                            name = "My PRs",
                            key = "2",
                            layout = "grouped",
                            search = "is:pr author:@me state:open archived:false sort:updated-desc",
                        },
                    },
                },
            },
        })
    end,
}


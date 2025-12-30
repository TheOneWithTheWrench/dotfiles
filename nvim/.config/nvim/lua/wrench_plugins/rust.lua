-- Configure rustaceanvim BEFORE the plugin loads
vim.g.rustaceanvim = {
    server = {
        settings = {
            ["rust-analyzer"] = {
                check = {
                    command = "clippy", -- Use clippy for diagnostics
                },
                cargo = {
                    allFeatures = true,
                },
                procMacro = {
                    enable = true,
                },
            },
        },
    },
}

return {
    {
        url = "https://github.com/mrcjkb/rustaceanvim",
        branch = "master",
        -- lazy = false is REQUIRED - rustaceanvim must NOT be lazy-loaded
        -- It's a filetype plugin that loads automatically when opening Rust files
        config = function() end,
    }
}

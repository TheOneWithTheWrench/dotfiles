return {
    {
        url = "https://github.com/mason-org/mason.nvim",
        cmd = { "Mason" },
        config = function()
            require("mason").setup()
        end,
    },
    {
        url = "https://github.com/mason-org/mason-lspconfig.nvim",
        ft = require("filetypes"),
        dependencies = {
            { url = "https://github.com/mason-org/mason.nvim"},
        },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "gopls", "buf_ls", "bashls", "ts_ls" },
            })
        end,
    },
}

return {
    url = "https://github.com/MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
        { url = "https://github.com/nvim-treesitter/nvim-treesitter" },
        { url = "https://github.com/nvim-tree/nvim-web-devicons" },
    },
    config = function()
        local opts = {
            completions = {
                lsp = {
                    enabled = true
                }
            },
        }

        require("render-markdown").setup(opts)
    end
}

return {
    url = "https://github.com/windwp/nvim-autopairs",
    ft = { "lua", "go", "yaml", "json", "graphql" },
    config = function()
        require("nvim-autopairs").setup({
            map_c_w = true,
        })
    end,
}

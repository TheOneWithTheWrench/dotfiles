return {
    url = "https://github.com/windwp/nvim-autopairs",
    ft = require("filetypes"),
    config = function()
        require("nvim-autopairs").setup({
            map_c_w = true,
        })
    end,
}

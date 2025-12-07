return {
    url = "https://github.com/folke/todo-comments.nvim",
    ft = {"go", "lua", "yaml", "yml", "json", "proto"},
    dependencies = {
        { url = "https://github.com/nvim-lua/plenary.nvim" }
    },
    config = function()
        require("todo-comments").setup()
    end,
}

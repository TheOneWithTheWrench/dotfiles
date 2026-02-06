return {
    url = "https://github.com/folke/todo-comments.nvim",
    ft = require("filetypes"),
    dependencies = {
        { url = "https://github.com/nvim-lua/plenary.nvim" }
    },
    config = function()
        require("todo-comments").setup()
    end,
}

return {
    url = "https://github.com/ThePrimeagen/harpoon",
    keys = {
        { lhs = "<leader>a", rhs = function() require("harpoon"):list():add() end,                                    desc = "Add current buffer to Harpoon" },
        { lhs = "<C-e>",     rhs = function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Open Harpoon list" },
    },
    branch = "harpoon2",
    dependencies = {
        { url = "https://github.com/nvim-lua/plenary.nvim" },
    },
    config = function()
        require("harpoon"):setup()
    end,
}

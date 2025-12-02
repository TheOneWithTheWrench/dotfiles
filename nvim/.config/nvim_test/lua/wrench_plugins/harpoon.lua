return {
    url = "https://github.com/ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
        { "https://github.com/nvim-lua/plenary.nvim" },
    },
    config = function()
        local harpoon = require("harpoon")

        harpoon.setup()

        vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Add current buffer to Harpoon" })
        vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Open Harpoon list" })
    end,
}

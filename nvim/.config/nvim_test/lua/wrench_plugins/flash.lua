return {
    url = "https://github.com/folke/flash.nvim",
    config = function()
        local opts = {
            label = {
                uppercase = false,
                before = true,
                after = false,
            },
            rainbow = {
                enabled = true,
                -- number between 1 and 9
                shade = 5,
            },
        }

        require("flash").setup(opts)

        vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash" })
    end,
}

return {
    url = "https://github.com/folke/flash.nvim",
    keys = {
        { mode = { "n", "x", "o" }, lhs = "s", rhs = function() require("flash").jump() end, desc = "Flash" },
    },
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
    end,
}

return {
    url = "https://github.com/github/copilot.vim",
    keys = {
        { lhs = "<leader>he", rhs = function()
            vim.cmd("Copilot enable")
            vim.cmd("Copilot status")
        end, desc = "Enable GitHub Copilot" },

        { lhs = "<leader>ho", rhs = function()
            vim.cmd("Copilot disable")
            vim.cmd("Copilot status")
        end, desc = "Disable GitHub Copilot" },
    },
}

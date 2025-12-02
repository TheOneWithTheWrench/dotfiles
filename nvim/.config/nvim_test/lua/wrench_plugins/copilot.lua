return {
    url = "https://github.com/github/copilot.vim",
    config = function()

        vim.keymap.set("n", "<leader>he", function()
            vim.cmd("Copilot enable")
            vim.cmd("Copilot status")
        end, { desc = "Enable GitHub Copilot" })

        vim.keymap.set("n", "<leader>ho", function()
            vim.cmd("Copilot disable")
            vim.cmd("Copilot status")
        end, { desc = "Disable GitHub Copilot" })
    end
}

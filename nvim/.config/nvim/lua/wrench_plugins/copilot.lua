local function notify(msg, level)
    vim.notify(msg, level or vim.log.levels.INFO, { title = "GitHub Copilot" })
end

return {
    url = "https://github.com/github/copilot.vim",
    -- Load on first insert, not at startup, so Neovim's startup time is
    -- untouched. Copilot only spins up once you actually start editing.
    event = "InsertEnter",
    config = function()
        -- copilot.vim self-starts from its FileType/InsertEnter autocmds, but
        -- those already fired by the time wrench lazy-loads the plugin. Re-fire
        -- them (scoped to copilot's own augroup so other plugins aren't touched)
        -- so it attaches the current buffer and starts the server. The start is
        -- deferred/async, so the editor never freezes.
        vim.api.nvim_exec_autocmds({ "FileType", "InsertEnter" }, { group = "github_copilot" })
    end,
    keys = {
        { lhs = "<leader>he", rhs = function()
            vim.g.copilot_enabled = 1
            notify("Enabled")
        end, desc = "Enable GitHub Copilot" },

        { lhs = "<leader>ho", rhs = function()
            vim.g.copilot_enabled = 0
            notify("Disabled")
        end, desc = "Disable GitHub Copilot" },
    },
}

return {
    url = "https://github.com/folke/trouble.nvim",
    keys = {
        { lhs = "<leader>xx", rhs = function() vim.cmd("Trouble diagnostics toggle filter.buf=0") end, desc = "Document Diagnostics (Trouble)" },
        { lhs = "<leader>xX", rhs = function() vim.cmd("Trouble diagnostics toggle") end,              desc = "Workspace Diagnostics (Trouble)" },
        { lhs = "<leader>xL", rhs = function() vim.cmd("Trouble loclist toggle") end,                  desc = "Location List (Trouble)" },
        { lhs = "<leader>xQ", rhs = function() vim.cmd("Trouble qflist toggle") end,                   desc = "Quickfix List (Trouble)" },
        {
            lhs = "[q",
            rhs = function()
                if require("trouble").is_open() then
                    require("trouble").prev({ skip_groups = true, jump = true })
                else
                    local ok, err = pcall(vim.cmd.cprev)
                    if not ok then
                        vim.notify(err, vim.log.levels.ERROR)
                    end
                end
            end,
            desc = "Previous Trouble/Quickfix Item"
        },
        {
            lhs = "]q",
            rhs = function()
                if require("trouble").is_open() then
                    require("trouble").next({ skip_groups = true, jump = true })
                else
                    local ok, err = pcall(vim.cmd.cnext)
                    if not ok then
                        vim.notify(err, vim.log.levels.ERROR)
                    end
                end
            end
        },
    },
    config = function()
        local opts = {
            use_diagnostic_signs = true,
            focus = true,
            win = {
                size = { height = 0.4 },
            },
            auto_close = true,
            keys = {
                ["<cr>"] = "jump_close", -- Close Trouble on enter hit... Annoying it stays open when hitting enter
                l = "fold_open",
                h = "fold_close",
            },
        }

        require("trouble").setup(opts)
    end,
}

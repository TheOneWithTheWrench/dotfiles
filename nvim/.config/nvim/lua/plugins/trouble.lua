return {
    {
        "folke/trouble.nvim",
        cmd = { "TroubleToggle", "Trouble" },
        opts = {
            use_diagnostic_signs = true,
            focus = true,
            win = {
                size = {height = 0.4},
            },
            auto_close = true,
            keys = {
                ["<cr>"] = "jump_close", -- Close Trouble on enter hit... Annoying it stays open when hitting enter
            },
        },
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",     desc = "Document Diagnostics (Trouble)" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle<cr>",                  desc = "Workspace Diagnostics (Trouble)" },
            { "<leader>xL", "<cmd>Trouble loclist toggle<cr>",                      desc = "Location List (Trouble)" },
            { "<leader>xQ", "<cmd>Trouble qflist toggle",                           desc = "Quickfix List (Trouble)" },
            { "[q", function()
                if require("trouble").is_open() then
                  require("trouble").prev({ skip_groups = true, jump = true })
                else
                  local ok, err = pcall(vim.cmd.cprev)
                  if not ok then
                    vim.notify(err, vim.log.levels.ERROR)
                  end
                end
              end,
              desc = "Previous Trouble/Quickfix Item",
            },
            { "]q", function()
                if require("trouble").is_open() then
                  require("trouble").next({ skip_groups = true, jump = true })
                else
                  local ok, err = pcall(vim.cmd.cnext)
                  if not ok then
                    vim.notify(err, vim.log.levels.ERROR)
                  end
                end
              end,
              desc = "Next Trouble/Quickfix Item",
            },
        },
    },
}

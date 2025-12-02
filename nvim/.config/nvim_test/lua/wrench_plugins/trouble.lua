return {
    url = "https://github.com/folke/trouble.nvim",
    config = function()
        local opts = {
            use_diagnostic_signs = true,
            focus = true,
            win = {
                size = {height = 0.4},
            },
            auto_close = true,
            keys = {
                ["<cr>"] = "jump_close", -- Close Trouble on enter hit... Annoying it stays open when hitting enter
                l = "fold_open",
                h = "fold_close",
            },
        }

        local trouble = require("trouble")

        trouble.setup(opts)

        vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",     { desc = "Document Diagnostics (Trouble)" })
        vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle<cr>",                  { desc = "Workspace Diagnostics (Trouble)" })
        vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>",                      { desc = "Location List (Trouble)" })
        vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle",                           { desc = "Quickfix List (Trouble)" })
        vim.keymap.set("n", "[q", function()
            if require("trouble").is_open() then
              require("trouble").prev({ skip_groups = true, jump = true })
            else
              local ok, err = pcall(vim.cmd.cprev)
              if not ok then
                vim.notify(err, vim.log.levels.ERROR)
              end
            end
          end,
          { desc = "Previous Trouble/Quickfix Item" }
        )
        vim.keymap.set("n", "]q", function()
            if require("trouble").is_open() then
              require("trouble").next({ skip_groups = true, jump = true })
            else
              local ok, err = pcall(vim.cmd.cnext)
              if not ok then
                vim.notify(err, vim.log.levels.ERROR)
              end
            end
        end)
    end,
}

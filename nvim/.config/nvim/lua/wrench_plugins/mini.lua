return {
    {
        url = "https://github.com/echasnovski/mini.comment",
        ft = require("filetypes"),
        config = function()
            local opts = {
                options = {
                    custom_commentstring = function()
                        return vim.bo.commentstring
                    end,
                },
            }
            require('mini.comment').setup(opts)
        end,
    },
    {
        url = "https://github.com/echasnovski/mini.diff",
        ft = require("filetypes"),
        config = function()
            local opts = {
                view = {
                    -- For some reason, there's a sign column conflict here. Mini.diff is fighting with Neovim if it should show the error or the mini.diff visualization
                    -- Setting this to be lower than the LSP priority seems to fix it... If anyone knows the actual fix here, I would appreciate it
                    priority = 9,
                }
            }

            require('mini.diff').setup(opts)
        end,
    },
    {
        url = "https://github.com/nvim-mini/mini.notify",
        config = function()
            local opts = {
                lsp_progress = {
                    enable = true,
                    duration_last = 3000,
                }
            }

            local notify = require('mini.notify')
            notify.setup(opts)

            vim.keymap.set("n", "<leader>uh", function() notify.clear() end, { desc = "Clear notifications" })
            vim.keymap.set("n", "<leader>un", function() notify.show_history() end,
                { desc = "Show notification history" })
        end,
    },
    {
        url = "https://github.com/nvim-mini/mini.files",
        config = function()
            local MiniFiles = require('mini.files')
            local opts = {
                mappings = {
                    close       = 'q',
                    go_in       = 'l',
                    go_in_plus  = '<CR>',
                    go_out      = 'h',
                    go_out_plus = 'H',
                    mark_goto   = "'",
                    mark_set    = 'm',
                    reset       = '-',
                    reveal_cwd  = '@',
                    show_help   = 'g?',
                    synchronize = '<leader>w',
                    trim_left   = '<',
                    trim_right  = '>',
                },
                options = {
                    -- Whether to delete permanently or move into module-specific trash
                    permanent_delete = true,
                    -- Whether to use for editing directories
                    use_as_default_explorer = true,
                },
            }
            MiniFiles.setup(opts)

            -- We need to put the keybind here to NOT lazy load the plugin
            vim.keymap.set("n", "-", function()
                local path = vim.api.nvim_buf_get_name(0)

                if path == "" then
                    path = vim.uv.cwd()
                end

                MiniFiles.open(path)
                MiniFiles.reveal_cwd()
            end, { desc = "Open file explorer" })
        end,
    },
}

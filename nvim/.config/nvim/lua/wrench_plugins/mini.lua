return {
    {
        url = "https://github.com/echasnovski/mini.comment",
        ft = { 'lua', 'go', 'yaml', 'json', 'graphql' },
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
        ft = { 'lua', 'go', 'yaml', 'json', 'graphql' },
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
}

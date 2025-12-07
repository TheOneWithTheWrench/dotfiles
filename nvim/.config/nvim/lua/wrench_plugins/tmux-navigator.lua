return {
    url = "https://github.com/christoomey/vim-tmux-navigator",
    keys = {
        { lhs = "<c-h>", rhs = function() vim.cmd("TmuxNavigateLeft") end,  desc = "Navigate to left tmux pane" },
        { lhs = "<c-j>", rhs = function() vim.cmd("TmuxNavigateDown") end,  desc = "Navigate to down tmux pane" },
        { lhs = "<c-k>", rhs = function() vim.cmd("TmuxNavigateUp") end,    desc = "Navigate to up tmux pane" },
        { lhs = "<c-l>", rhs = function() vim.cmd("TmuxNavigateRight") end, desc = "Navigate to right tmux pane" },
    },
}

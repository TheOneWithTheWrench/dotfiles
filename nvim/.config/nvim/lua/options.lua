vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set nowrap")
vim.cmd("set formatoptions-=t")
vim.g.mapleader = " "

--[[
vim.g.netrw_banner = 0
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
]]
--

local opt = vim.opt
opt.autowrite = true
opt.confirm = false
opt.number = true
opt.relativenumber = true
opt.ignorecase = true
opt.smartcase = true
opt.smartindent = true
opt.clipboard = "unnamedplus"
opt.cursorline = true
opt.undofile = true
opt.undolevels = 10000
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap
vim.opt_local.wrap = false
opt.timeoutlen = 300
opt.scrolloff = 10
opt.sidescrolloff = 8
opt.inccommand = "split"
opt.swapfile = false
opt.winborder = "rounded"
opt.signcolumn = "yes"
opt.laststatus = 3

vim.diagnostic.config({
    virtual_text = true
})

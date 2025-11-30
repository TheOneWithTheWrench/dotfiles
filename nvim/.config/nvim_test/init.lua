-- Options
vim.g.mapleader = " "
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set nowrap")
vim.cmd("set formatoptions-=t")

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
opt.wildmode = "longest:full,full"
opt.winminwidth = 5
opt.wrap = false
opt.timeoutlen = 300
opt.scrolloff = 10
opt.sidescrolloff = 8
opt.inccommand = "split"

-- Add wrench to runtimepath
-- vim.opt.rtp:prepend(vim.fn.stdpath("config") .. "/../nvim/pack/plugins/start/wrench")

local wrenchpath = vim.fn.stdpath("data") .. "/wrench"
if not vim.loop.fs_stat(wrenchpath) then
    vim.fn.system({
        "git",
        "clone",
        "https://github.com/TheOneWithTheWrench/wrench-package-manager.git",
        wrenchpath,
    })
end
vim.opt.rtp:prepend(wrenchpath)

local wrench = require("wrench")

wrench.add({
	{ url = "https://github.com/ellisonleao/gruvbox.nvim", branch = "main" },
	{
		url = "https://github.com/folke/which-key.nvim",
		branch = "main",
		config = function()
			print("which-key config running!")
			require("which-key").setup()
		end,
	},
})

vim.cmd.colorscheme("gruvbox")

-- Keymaps
vim.keymap.set("n", "<leader>ws", "<cmd>WrenchSync<cr>", { desc = "Wrench: Sync" })
vim.keymap.set("n", "<leader>wr", "<cmd>WrenchRestore<cr>", { desc = "Wrench: Restore" })
vim.keymap.set("n", "<leader>wg", "<cmd>WrenchGetRegistered<cr>", { desc = "Wrench: Get Registered" })
vim.keymap.set("n", "<leader>wu", "<cmd>WrenchUpdate<cr>", { desc = "Wrench: Update" })

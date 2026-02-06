vim.loader.enable()

local wrenchpath = vim.fn.expand("~/lua/wrench")
vim.opt.rtp:prepend(wrenchpath)

-- local wrenchpath = vim.fn.stdpath("data") .. "/wrench"
-- if not vim.loop.fs_stat(wrenchpath) then
-- 	vim.fn.system({
-- 		"git",
-- 		"clone",
-- 		"https://github.com/TheOneWithTheWrench/wrench.nvim.git",
-- 		wrenchpath,
-- 	})
-- end
-- vim.opt.rtp:prepend(wrenchpath)

require("options")
require("auto_commands")
require("keymaps")
require("wrench").setup("wrench_plugins")

-- Keymaps
vim.keymap.set("n", "<leader>es", "<cmd>WrenchSync<cr>",            { desc = "Wrench: Sync" })
vim.keymap.set("n", "<leader>er", "<cmd>WrenchRestore<cr>",         { desc = "Wrench: Restore" })
vim.keymap.set("n", "<leader>eg", "<cmd>WrenchGetRegistered<cr>",   { desc = "Wrench: Get Registered" })
vim.keymap.set("n", "<leader>eu", "<cmd>WrenchUpdate<cr>",          { desc = "Wrench: Update" })

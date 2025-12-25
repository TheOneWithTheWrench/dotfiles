-- Disable command-line window (q:, q/, q?)
vim.keymap.set("n", "q:", "<Nop>", { noremap = true, silent = true })
vim.keymap.set("n", "q/", "<Nop>", { noremap = true, silent = true })
vim.keymap.set("n", "q?", "<Nop>", { noremap = true, silent = true })

-- Close window
vim.keymap.set({"n", "v"}, "<leader>q", "<cmd>q<cr>", { noremap = true, silent = true, desc = "Close window" })
vim.keymap.set({"n", "v"}, "<leader>Q", "<cmd>q!<cr>", { noremap = true, silent = true, desc = "Close window but harder" })

-- Save file
vim.keymap.set("n", "<leader>w", "<cmd>wall<cr>", { noremap = true, silent = true, desc = "Save all files" })

-- Maybe find a better place for this later
-- Diagnostic
local diagnostic_goto = function(next, severity)
	local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		go({ severity = severity })
	end
end

-- Diagnostic
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

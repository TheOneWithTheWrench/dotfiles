-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
	pattern = {
		"PlenaryTestPopup",
		"help",
		"lspinfo",
		"man",
		"notify",
		"qf",
		"query",
		"spectre_panel",
		"startuptime",
		"tsplayground",
		"neotest-output",
		"checkhealth",
		"neotest-summary",
		"neotest-output-panel",
        "gitsigns-blame",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- I want Neovim to name my tmux sessions to the current working directory. This autocommand does that.
vim.api.nvim_create_augroup("tmux", { clear = true })
if os.getenv("TMUX") then
	local function is_git_repo()
		return os.execute("git rev-parse --is-inside-work-tree > /dev/null 2>&1") == 0
	end
	-- Function to get the project root using git or fallback to current working directory
	local function get_project_root()
		-- Try run git rev-parse --show-toplevel to see if we are in a git repo
		if is_git_repo() then
			local git_dir = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
			return vim.fn.fnamemodify(git_dir, ":t")
		else
			return vim.fn.fnamemodify(vim.loop.cwd(), ":t")
		end
	end

	-- Rename the tmux window to the project name on certain events
	vim.api.nvim_create_autocmd({ "BufReadPost", "FileReadPost", "BufNewFile", "FocusGained" }, {
		group = "tmux",
		callback = function()
			local project_name = get_project_root()
			os.execute("tmux rename-window " .. project_name)
		end,
	})

	-- Restore automatic renaming when Neovim is left or focus is lost
	vim.api.nvim_create_autocmd({ "VimLeave", "FocusLost" }, {
		group = "tmux",
		callback = function()
			os.execute("tmux set-window-option automatic-rename")
		end,
	})
end
